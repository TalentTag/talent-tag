class Industry < ActiveRecord::Base

  has_many :keyword_groups

  validates :name, presence: true, uniqueness: true

end
