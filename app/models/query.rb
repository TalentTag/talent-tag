class Query < ActiveRecord::Base

  default_scope { order(created_at: :desc) }

end
