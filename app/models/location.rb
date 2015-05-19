class Location < ActiveRecord::Base

  scope :name_like, ->(term) { where{ name.matches "%#{ term.neat.downcase }%" } }

  def self.first_by_name(term)
    where(name: term).pluck(:id).first
  end
end
