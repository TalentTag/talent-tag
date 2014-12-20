class Portfolio < ActiveRecord::Base

  self.table_name = :portfolio

  belongs_to :user, class_name: "Specialist"

end
