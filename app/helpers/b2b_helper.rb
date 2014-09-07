module B2bHelper

  def notifications
    ids = current_user.follows.map { |f| f.following.id }
    Notification.where ids, current_user.last_notifications_check
  end

  %w(status_change new_post).each do |event|
    define_method("notification_#{ event }") do |notification|
      render partial: "b2b/partials/notifications/#{ event }", locals: { notification: notification }
    end
  end

end
