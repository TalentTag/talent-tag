class Entry < ActiveRecord::Base

  self.primary_key = :id

  paginates_per 10

  belongs_to :source

  validates :id, presence: true, uniqueness: true

  default_scope -> { order created_at: :desc }
  scope :from_published_sources, -> { joins(:source).where('sources.hidden' => false).references(:sources) }

  def self.filter params={}
    entries = all
    entries = entries.where(source_id: params[:source]) if params[:source]
    entries = entries.from_published_sources if params[:published]
    entries.page(params[:page] || 1)
  end

end
