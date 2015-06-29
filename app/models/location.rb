class Location < ActiveRecord::Base

  scope :name_like, ->(term) { where{ name.matches "%#{ term.neat.downcase }%" } }

  default_scope -> { order :id }

  def self.first_by_name(term)
    where(name: term).pluck(:id).first
  end
end
