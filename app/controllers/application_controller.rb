class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user, :current_account, :signed_in?, :is_employer?, :is_specialist?

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
    return render text: "Error 401", status: :unauthorized unless signed_in?
  end

  def forbid_authenticated!
    return render text: "Error 403", status: :forbidden if signed_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    render nothing: true, status: :forbidden
  end



  protected

  def sign_user_in user=nil, options={}
    user ||= @user
    if user.kind_of? User
      session[:user] = user.email
      session[:role] = options[:as] if options[:as].present?
      user.tap do |u|
        u.last_login_at = Time.now
        u.generate_auth_token
      end.save validate: false
      user.generate_cookie { |cookie| cookies[:rememberme] = cookie } if params[:rememberme]
    end
    signed_in?
  end


  def account_type
    @account_type ||= session[:role].try :to_sym
  end

  def is_employer?
    account_type == :employer
  end

  def is_specialist?
    account_type == :specialist
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def fetch_account_data
    gon.push \
      user:           current_user,
      company:        current_account,
      keyword_groups: KeywordGroup.all,
      industries:     Industry.all,
      areas:          Area.all,
      searches:       current_user.searches,
      folders:        current_user.folders
  end

end
