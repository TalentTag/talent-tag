class Entry < ActiveRecord::Base

  include AASM
  include PrepareQuery

  self.primary_key = :id

  ENTRIES_PER_PAGE = 10
  paginates_per ENTRIES_PER_PAGE

  belongs_to :user, class_name: 'Specialist'
  belongs_to :source
  has_many :comments
  has_many :duplicates, class_name: 'Entry', foreign_key: :duplicate_of

  before_create :link_to_author
  after_create :notify

  validates :id, presence: true, uniqueness: true
  validates_presence_of :body

  default_scope -> { order created_at: :desc }
  scope :from_published_sources, -> { joins(:source).where('sources.hidden' => false).references(:sources) }
  scope :except_blacklisted_by, -> (user) { where.not id: user.blacklist }
  scope :visible, -> { where state: :normal }
  scope :marked, -> { where state: :marked }
  scope :within, -> (date) { where("created_at > ?", date.beginning_of_day).where("created_at < ?", date.end_of_day) }

  sifter :location_match do |term|
    location.matches "%#{ term.neat.downcase }%"
  end
  scope :location_like, ->(term) { where{ sift :location_match, term } }

  scope :with_location, -> { where{ (location.not_eq nil) | (location_id.not_eq nil) } }

  def self.filter params={}
    page = params[:page] || 1

    if params[:query] || params[:location]

      excepts = {}
      excepts[:id] = params[:blacklist].map(&:to_i) if params[:blacklist].present?
      excepts[:source_id] = Source.unpublished unless params[:published].nil? or Source.unpublished.empty?
      excepts[:user_id] = 0 if params[:club_members_only]

      entries = search(
        search_query(params[:query]),
        with: prepare_conditions(params),
        without: excepts,
        retry_stale: true,
        excerpts: { around: 250 },
        order: 'created_at DESC'
      )

      entries.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
      entries.page(page).per(ENTRIES_PER_PAGE)
    else
      entries = visible
      entries = entries.where(source_id: params[:source]) if params[:source]
      entries = entries.from_published_sources if params[:published]
      entries.page(page).load
    end
  end


  def author
    user.presence || super
  end


  def link_to_author!
    link_to_author && save
  end

  def hashtags
    body.scan(/#(\S+)/).flatten.reject { |t| t=='talenttag' }.uniq
  end


  aasm_column :state
  aasm do
    state :normal, initial: true
    state :marked
    state :deleted

    event :mark_as_deleted do
      transitions to: :marked, from: :normal
    end

    event :delete do
      transitions to: :deleted, from: %i(normal marked)
    end

    event :restore do
      transitions to: :normal, from: :marked
    end
  end

  def self.update_locations
    Location.find_each do |place|
      querystring = place.synonyms.map { |e| "\"#{ e }\"" }.join(' | ')

      ids = Entry.search_for_ids querystring, with: { location_id: 0 }

      Entry.where{
        (
          (sift :location_match, place.name) | (location.in place.synonyms) | (id.in ids)
        ) & (location_id.eq nil)
      }.update_all(location_id: place.id)
    end
  end

  protected

  def link_to_author
    unless user_id
      user = Identity.find_by(anchor: author['guid']).user rescue nil
      self.user_id = user.try(:id)
    end
  end

  def notify
    user.notifications.create(event: "new_post", data: { id: id }) rescue nil
  end

  def self.prepare_conditions(params)
    {
      source_id: params[:source],
      duplicate_of: 0,
      location_id: params[:location] && Location.name_like(params[:location]).pluck(:id).first
    }.delete_if { |k, v| v.nil? }
  end

end
