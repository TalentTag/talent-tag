class Message < ActiveRecord::Base

  belongs_to :conversation

  after_create :touch_conversation

  default_scope -> { order(:created_at).limit(20) }


  def user
    user_class = source == 'employer' ? User : Specialist
    user_class.find user_id
  end


  protected

  def touch_conversation
    conversation.update last_message_at: Time.now
  end

end
