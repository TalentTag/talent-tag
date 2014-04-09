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
      conditions = {}.tap do |c|
        c[:source_id] = params[:source] if params[:source].present?
      end
      excepts = {}.tap do |e|
        e[:id] = params[:blacklist].first unless params[:blacklist].nil? || params[:blacklist].empty?
        e[:source_id] = Source.unpublished unless params[:published].nil? or Source.unpublished.empty?
      end

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

end
