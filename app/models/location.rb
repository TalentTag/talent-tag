class Location < ActiveRecord::Base

  scope :name_like, ->(name) { where('locations.name ILIKE ?', "%#{ name.neat }%") }

end
