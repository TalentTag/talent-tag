class Search < ActiveRecord::Base

  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :query, presence: true

  before_create :touch
  before_validation :modify_name, on: :create


  def blacklisted
    super.map { |id| id.to_i }
  end

  def blacklist! entry
    self.blacklisted ||= []
    blacklisted_will_change!
    self.blacklisted = blacklisted << entry.id
    save
  end

  def touch
    self.last_checked_at = Time.now
  end

  def touch!
    touch && save
  end

  def modify_name
    self.name = "#{ name } | #{ filters['location'] }" if filters['location'].present?
  end

  def new_entries_count
    @count ||= Entry.search_for_ids(query, without: { source_id: Source.unpublished }, with: { fetched_at: last_checked_at..Time.now }).total_count
  end


  def as_json params
    super(params).merge 'new_entries_count'=>new_entries_count
  end

end
