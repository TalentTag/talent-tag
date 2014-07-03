class Message < ActiveRecord::Base

  belongs_to :conversation, dependent: :destroy

  after_create :touch_conversation

  # scope :connections, -> (user) { where "user_id IN (?) OR addressee_id IN (?)", [user1, user2], [user1, user2] }
  # scope :conversation, -> (user1, user2) { where "user_id IN (?) OR addressee_id IN (?)", [user1, user2], [user1, user2] }
  default_scope -> { order :created_at }


  def user
    User.find user_id
  end


  protected

  def touch_conversation
    conversation.update last_message_at: Time.now
  end

end
