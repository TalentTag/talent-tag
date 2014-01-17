class UsersController < ApplicationController

  respond_to :json


  def update
    authorize! :update, current_user
    current_user.update_attributes(update_params)
    respond_with current_user
  end

  def signin
    authorize! :signin_as, user
    user = User.find_by! id: params[:id]
    session[:prev_user] = session[:user]
    sign_user_in(user)
    redirect_to account_path
  end


  private

  def update_params
    params.require(:user).permit :firstname, :midname, :lastname, :phone
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
