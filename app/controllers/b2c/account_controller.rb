class B2c::AccountController < B2c::BaseController

  def show
    gon.user = @user = User.find_by! id: params[:id]
    gon.profile_editable = @user==current_user
    render "account/b2c"
  end

end
