class NotificationsService

  def initialize user
    @user = user
  end

  def all options={}
    ids = @user.follows.map { |f| f.following_id }
    if options[:unseen_only]
      Notification.where ids, last_check
    else
      Notification.where ids
    end
  end

  def mark_checked!
    KeyValue.setex "notifications:checked:#{ @user.id }", 7.days, Time.now.to_i
  end

  def last_check
    Time.at(KeyValue.get("notifications:checked:#{ @user.id }").to_i).to_datetime
  end

end
