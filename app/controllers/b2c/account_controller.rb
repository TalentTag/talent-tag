class B2c::AccountController < B2c::BaseController

  def show
    @user = User.find_by! id: params[:id]
    gon.user = @user.profile
    render "account/b2c"
  end

end
