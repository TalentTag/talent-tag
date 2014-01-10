class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user, :current_account, :signed_in?

  before_filter :mailer_set_url_options

  def current_user
    @current_user ||= if session[:user]
      User.find_by email: session[:user]
    elsif cookies[:rememberme]
      cookie_parts = cookies[:rememberme].split('|')
      user = User.find cookie_parts.first
      session[:user] = user.email if user && cookie_parts.last == user.auth_token
      user
    end
  end

  def signed_in?
    !!current_user
  end

  def current_account
    current_user.company if signed_in?
  end

  def require_authentication!
    return render nothing: true, status: :unauthorized unless signed_in?
  end

  def forbid_authenticated!
    return render nothing: true, status: :forbidden if signed_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    render nothing: true, status: :forbidden
  end




  protected

  def sign_user_in user=nil, options={}
    user ||= @user
    if user.kind_of? User
      session[:user] = user.email
      user.generate_cookie do |cookie|
        cookies[:rememberme] = { value: cookie, expires: 1.month.from_now }
      end if params[:rememberme]
      user.tap { |u| u.last_login_at = Time.now }.save validate: !options[:skip_validation]
    end
  end

  def fetch_account_data
    gon.push \
      keyword_groups: KeywordGroup.all,
      industries:     Industry.all,
      areas:          Area.all,
      searches:       current_user.searches,
      folders:        current_user.folders
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

end
