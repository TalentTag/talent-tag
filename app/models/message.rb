class Message < ActiveRecord::Base

  belongs_to :conversation

  # scope :connections, -> (user) { where "user_id IN (?) OR addressee_id IN (?)", [user1, user2], [user1, user2] }
  # scope :conversation, -> (user1, user2) { where "user_id IN (?) OR addressee_id IN (?)", [user1, user2], [user1, user2] }
  default_scope -> { order :created_at }

end
