class Source < ActiveRecord::Base

  self.primary_key = :id

  has_many :entries

  validates_presence_of :name
  validates :id, presence: true, uniqueness: true

  scope :visible, -> { where hidden: false }
  scope :invisible, -> { where hidden: true }

  def self.published() visible.map &:id end
  def self.unpublished() invisible.map &:id end

end
