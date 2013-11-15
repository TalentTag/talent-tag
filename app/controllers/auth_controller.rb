class AuthController < ApplicationController

  before_action :require_authentication!, only: :signout


  def signin
    if @user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])
      sign_user_in
      redirect_to account_path
    else
      render json: { credentials: ["Неверный email или пароль"] }, status: :unauthorized
    end
  end

  def signout
    current_user.update_attribute :auth_token, nil
    session.clear
    cookies.delete :rememberme
    redirect_to root_path, notice: "Вы вышли из системы"
  end

  def forgot
    if user = User.find_by(email: params[:user][:email])
      user.generate_forgot_token!
      render nothing: true
    else
      render json: { errors: { email: ["Указанный e-mail в базе не зарегистрирован"] } }, status: :not_found
    end
  end

end
