class PublicController < ApplicationController

  before_action :find_user_by_forgot_token, only: %i(edit_password update_password)


  def update_password
    if @user.update_password! password_params
      sign_user_in
      redirect_to account_path
    else
      render :edit_password
    end
  end


  private

  def find_user_by_forgot_token
    @user = User.find_by! forgot_token: params['token']
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
