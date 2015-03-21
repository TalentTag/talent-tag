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

  default_scope -> { order created_at: :desc }
  scope :from_published_sources, -> { joins(:source).where('sources.hidden' => false).references(:sources) }
  scope :except_blacklisted_by, -> (user) { where.not id: user.blacklist }
  scope :visible, -> { where state: :normal }
  scope :marked, -> { where state: :marked }
  scope :within, -> (date) { where("created_at > ?", date.beginning_of_day).where("created_at < ?", date.end_of_day) }


  def self.filter params={}
    page = params[:page] || 1

    if params[:query]
      conditions = {}
      conditions[:source_id] = params[:source] if params[:source].present?
      conditions[:duplicate_of] = 0
      if params[:location].present?
        location = Location.find(:first, conditions: ["lower(name) = ?", params[:location].mb_chars.downcase.to_s])
        conditions[:location_id] = location.id if location.present?
      end

      excepts = {}
      # excepts[:id] = params[:blacklist].map(&:to_i) if params[:blacklist].present?
      excepts[:source_id] = Source.unpublished unless params[:published].nil? or Source.unpublished.empty?
      excepts[:user_id] = 0 if params[:club_members_only]

      entries = search(
        search_query(params[:query]),
        with: conditions,
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

end
