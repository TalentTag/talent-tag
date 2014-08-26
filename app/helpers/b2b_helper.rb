module B2bHelper

  def notifications
    @notifications ||= begin
      ids = current_user.follows.map { |f| f.following.id }
      Notification.where ids
    end
  end

end
