class Location < ActiveRecord::Base

  scope :name_like, ->(term) { where{ name.matches "%#{ term.neat.downcase }%" } }

end
