class AuthController < ApplicationController

  respond_to :json

  before_action :require_authentication!, only: :signout



  def signin
    if @user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])
      sign_user_in @user, as: params[:type]
      render nothing: true, status: :no_content
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
      cookies.delete :role
    end
    redirect_to account_path, notice: "Вы вышли из системы"
  end

  def forgot
    if user = User.find_by(email: params[:user][:email])
      user.generate_forgot_token!
      flash[:notice] = "Инструкции по восстановлению пароля высланы на адрес #{ params[:user][:email] }"
      render nothing: true
    else
      render json: { errors: { email: ["E-mail в базе не зарегистрирован"] } }, status: :not_found
    end
  end



  def callback
    @params = env["omniauth.auth"].slice(:provider, :uid, :info, :extra)
    # raise @params = env["omniauth.auth"].to_yaml
    if @user = Identity.from_omniauth(omniauth_params(@params), current_user).try(:user)
      sign_user_in(@user, as: :specialist) unless signed_in?
      redirect_to account_path
    end
  end

  def from_omniauth
    if sign_user_in(Identity.from_omniauth(omniauth_params(params)).try(:user), as: :specialist)
      redirect_to account_path
    else
      @params = params.slice(:provider, :uid, :info)
      identity = User.find_by(email: params[:info][:email]).identities.first
      flash.now[:alert] = if identity
        "Этот адрес уже был зарегистрирован через #{ identity.provider.capitalize }. Если это Ваш e-mail, используйте для входа аккаунт #{ identity.provider.capitalize } или воспользуйтесь опцией восстановления пароля."
      else
        "Этот адрес уже зарегистрирован в системе. Если пароль от аккаутна утерян, воспользуйтесь опцией восстановления пароля."
      end
      render :callback
    end
  end


  private

  def omniauth_params params
    { provider: params[:provider], uid: params[:uid], info: params[:info], extra: params[:extra], user_attributes: { email: params[:info][:email]} }
  end

end
