class Message < ActiveRecord::Base

  belongs_to :conversation

  after_create :touch_conversation

  default_scope -> { order :created_at }


  def user
    User.find user_id
  end


  protected

  def touch_conversation
    conversation.update last_message_at: Time.now
  end

end
