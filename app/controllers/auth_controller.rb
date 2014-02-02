class AuthController < ApplicationController

  respond_to :json

  before_action :require_authentication!, only: :signout


  def signin
    if @user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])
      sign_user_in
      respond_with current_user
    else
      render json: { credentials: ["Неверный email или пароль"] }, status: :unauthorized
    end
  end

  def signout
    current_user.update auth_token: nil
    if session[:prev_user]
      session[:user] = session.delete(:prev_user)
    else
      session.clear
      cookies.delete :rememberme
    end
    redirect_to root_path, notice: "Вы вышли из системы"
  end

  def forgot
    if user = User.find_by(email: params[:user][:email])
      user.generate_forgot_token!
      flash[:notice] = "Инструкции по восстановлению пароля высланы на адрес #{ params[:user][:email] }"
      render nothing: true
    else
      render json: { errors: { email: ["Указанный e-mail в базе не зарегистрирован"] } }, status: :not_found
    end
  end

  def callback
    @params = env["omniauth.auth"].slice(:provider, :uid)
    if @user = Identity.find_by(provider: @params[:provider], uid: @params[:uid]).try(:user)
      sign_user_in
      redirect_to account_b2c_path
    else
      render :callback, layout: 'b2c'
    end
  end

  def from_omniauth
    sign_user_in User.from_omniauth(params)
    redirect_to account_b2c_path
  end

end
