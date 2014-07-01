class B2c::AccountController < B2c::BaseController

  def show
    @user = User.find_by! id: params[:id]
    gon.user = @user.profile
    gon.current_user = current_user

    @conversation     = Conversation.between([@user, current_user]).first
    gon.conversation  = @conversation
    gon.messages = @conversation.try :messages

    render "account/b2c"
  end

end
