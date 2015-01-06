class NotificationsService

  def initialize user
    @user = user
  end

  def all options={}
    case @user.class.name
      when 'User'
        ids = @user.follows.pluck :id
        notifications = Notification::Specialists.where(author_id: ids)
        notifications = notifications.where('created_at > ?', last_check) if options[:unseen_only]
        notifications
      when 'Specialist'
        ids = @user.followed_by.pluck :id
        notifications = Notification::Users.where(author_id: ids)
        notifications = notifications.where('created_at > ?', last_check) if options[:unseen_only]
        notifications
    end.limit(options[:limit] || 20)
  end

  def unseen options={}
    all options.merge(unseen_only: true)
  end

  def mark_checked!
    KeyValue.setex "notifications:checked:#{ @user.id }", 7.days, Time.now.to_i
  end

  def last_check
    Time.at(KeyValue.get("notifications:checked:#{ @user.id }").to_i).to_datetime
  end

end
