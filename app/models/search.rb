class Search < ActiveRecord::Base

  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :query, presence: true, uniqueness: { scope: :user_id }


  def blacklisted
    super.map { |id| id.to_i }
  end

  def blacklist! entry
    self.blacklisted ||= []
    blacklisted_will_change!
    self.blacklisted = blacklisted << entry.id
    save
  end

end
