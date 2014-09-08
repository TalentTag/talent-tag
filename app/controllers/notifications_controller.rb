class NotificationsController < ApplicationController

  before_action do
    @notifications_service = NotificationsService.new(current_user)
  end


  def index
    @notifications = @notifications_service.all
    @notifications_service.mark_checked!
  end

  def mark_checked
    @notifications_service.mark_checked!
    render nothing: true, status: :no_content
  end

end
