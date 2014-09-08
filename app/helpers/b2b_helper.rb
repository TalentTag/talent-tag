module B2bHelper

  def notifications
    @recent_notifications ||= NotificationsService.new(current_user).all unseen_only: true
  end

  %w(status_change new_post).each do |event|
    define_method("notification_#{ event }") do |notification|
      render partial: "b2b/partials/notifications/#{ event }", locals: { notification: notification }
    end
  end

end
