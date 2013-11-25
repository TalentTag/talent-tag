class Entry < ActiveRecord::Base

  self.primary_key = :id

  belongs_to :source
  has_and_belongs_to_many :keyword_groups

  validates :id, presence: true, uniqueness: true

end
