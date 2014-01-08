class Search < ActiveRecord::Base

  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :query, presence: true, uniqueness: { scope: :user_id }

end
