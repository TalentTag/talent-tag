class Folder < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :entries, -> { limit 10 }

  validates :name, presence: true, uniqueness: { scope: :user_id }

end
