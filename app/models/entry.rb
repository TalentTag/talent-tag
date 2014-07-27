class Entry < ActiveRecord::Base

  self.primary_key = :id

  ENTRIES_PER_PAGE = 10
  paginates_per ENTRIES_PER_PAGE

  belongs_to :source
  has_many :comments

  validates :id, presence: true, uniqueness: true

  default_scope -> { order created_at: :desc }
  scope :from_published_sources, -> { joins(:source).where('sources.hidden' => false).references(:sources) }
  scope :except_blacklisted_by, -> (user) { where.not id: user.blacklist }


  def self.filter params={}
    page = params[:page] || 1
    if params[:query]
      kw = KeywordGroup.where.contains(keywords: [params[:query]]).flat_map &:keywords
      params[:query] = kw.map { |w| "(#{w})" }.join(' | ') unless kw.empty?

      conditions = {}
      conditions[:source_id] = params[:source] if params[:source].present?

      excepts = {}
      excepts[:id] = params[:blacklist] unless params[:blacklist].nil? || params[:blacklist].empty?
      excepts[:source_id] = Source.unpublished unless params[:published].nil? or Source.unpublished.empty?

      entries = search(params[:query], with: conditions, without: excepts, retry_stale: true, excerpts: {around: 250}, order: 'created_at DESC')
      entries.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
      entries.page(page).per(ENTRIES_PER_PAGE)
    else
      entries = self
      entries = entries.where(source_id: params[:source]) if params[:source]
      entries = entries.from_published_sources if params[:published]
      entries.page(page).load
    end
  end


  def identity
    Identity.find_by(anchor: author['guid']) rescue nil
  end

  def user
    identity.try :user # TODO move to decorator
  end


  def hashtags
    body.scan(/#(\S+)/).flatten.reject { |t| t=='talenttag' }.uniq
  end

end
