class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :entry

  before_create do
    self.company_id = user.company.id
  end

end
