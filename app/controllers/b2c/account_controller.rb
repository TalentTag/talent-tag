class B2c::AccountController < B2c::BaseController

  def show
    @user = User.find_by! id: params[:id]
    gon.user = @user.profile
    gon.current_user = current_user

    @conversation     = Conversation.find_by(participants: [@user, current_user].map(&:id).sort)
    gon.conversation  = @conversation
    gon.messages = @conversation.try :messages

    render "account/b2c"
  end

end
