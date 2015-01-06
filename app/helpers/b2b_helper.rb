module B2bHelper

  def notifications
    @recent_notifications ||= NotificationsService.new(current_user).unseen
  end

  %w(status_change new_post following).each do |event|
    define_method("notification_#{ event }") do |notification|
      render partial: "partials/notifications/#{ event }", locals: { notification: notification }
    end
  end

end
