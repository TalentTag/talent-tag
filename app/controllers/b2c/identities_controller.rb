class B2c::IdentitiesController < B2c::BaseController

  respond_to :json


  def create
    identity = Identity.new create_params
    if identity.save
      sign_user_in identity.user, as: :specialist
      render nothing: true, status: :created
    else
      return render json: { errors: { 'user.email' => "Этот адрес уже зарегистрирован в системе. Если пароль от аккаутна утерян, воспользуйтесь опцией восстановления пароля." } }, status: 422 if User.exists?(email: params[:identity][:user_attributes][:email])
    end
  end


  protected

  def create_params
    profile_params = %w(location image image_source nickname birthdate education work url_facebook url_twitter url_vkontakte url_google_oauth2)
    cparams = params.require(:identity).permit(:provider, :uid, user_attributes: [:email, :firstname, :lastname, profile: profile_params])
    password = Digest::MD5.hexdigest(Time.now.to_s + cparams[:uid] + cparams[:provider])
    cparams[:user_attributes][:password] = cparams[:user_attributes][:password_confirmation] = password
    cparams
  end

end
