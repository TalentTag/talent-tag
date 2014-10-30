class B2c::AccountController < B2c::BaseController

  def show
    gon.user = @user = User.find_by! id: params[:id]
    render "b2c/account"
  end

end
