class NotificationsController < ApplicationController

  def index
    @notifications = begin
      ids = current_user.follows.map { |f| f.following.id }
      Notification.where ids
    end
    current_user.check_notifications!
  end

  def mark_checked
    current_user.check_notifications!
    render nothing: true, status: :no_content
  end

end
