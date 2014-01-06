class Entry < ActiveRecord::Base

  self.primary_key = :id

  ENTRIES_PER_PAGE = 10
  paginates_per ENTRIES_PER_PAGE

  belongs_to :source

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
        c[:source_id] = Source.published if params[:published]
      end
      excepts = {}.tap do |e|
        e[:id] = params[:user].blacklist.entries if params[:user]
      end
      Entry.search(params[:query], with: conditions, without: excepts, retry_stale: true).page(page).per(ENTRIES_PER_PAGE)
    else
      entries = if params[:user] then except_blacklisted_by(params[:user]) else all end
      entries = entries.where(source_id: params[:source]) if params[:source]
      entries = entries.from_published_sources if params[:published]
      entries.page(page)
    end
  end

  def blacklist_by user
    user.blacklist.add self
  end

end
