class Conversation < ActiveRecord::Base

  has_many :messages

  has_many :conversations_users
  has_and_belongs_to_many :users

  scope :with, ->(user) { user.conversations }
  scope :between, ->(users) { joins(:conversations_users).where(conversations_users: {user_id: users.map{|u| u.try(:id) || u.to_i }}).distinct(:conversation) }

  def recipients user
    users.keep_if { |u| u.id != user.id }
  end

  def recipient user
    # only 1-1 chats yet
    recipients(user).first
  end

  def last_user_activity(user)
    conversations_users.where(user_id: user.id).first.try(:last_activity_at)
  end

  def unread_messages(user)
    messages.where.not(user_id: user.id).where("created_at > '#{last_user_activity(user)}'").count
  end

  def touch_activity(user)
    conversations_users.where(user_id: user.id).update_all(last_activity_at: Time.now)
  end

end
