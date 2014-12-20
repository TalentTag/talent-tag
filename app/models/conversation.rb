class Conversation < ActiveRecord::Base

  has_many :messages, dependent: :destroy
  has_many :conversations_users, dependent: :destroy
  # has_and_belongs_to_many :users

  default_scope -> { order last_message_at: :desc }


  def self.between users
    users[0] = User.find(users[0]) unless users[0].kind_of? User
    users[1] = users[1].id if users[1].kind_of? User
    ConversationsUser.find_by(conversation_id: users[0].conversations_users.pluck(:conversation_id), user_id: users[1]).try :conversation
  end

  def recipients user
    users.keep_if { |u| u.id != user.id }
  end

  def recipient user
    # only 1-1 chats yet
    recipients(user).first
  end

  def last_message
    messages.last
  end

  def last_user_activity(user)
    conversations_users.where(user_id: user.id).first.try(:last_activity_at)
  end

  def unread_messages(user)
    msg = messages.where.not(user_id: user.id)
    msg = msg.where("created_at > '#{last_user_activity(user)}'") if last_user_activity(user)
    msg
  end

  def unread_messages_count(user)
    unread_messages(user).count
  end

  def touch_activity!(user)
    conversations_users.where(user_id: user.id).update_all(last_activity_at: Time.now)
  end

end
