class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user, :current_account, :signed_in?, :is_employer?, :is_specialist?

  before_action :include_current_user
  before_action do
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  before_action do
    ConversationsService.init(current_user) if signed_in?
  end

  def current_user
    @current_user ||= if session[:user] && account_type.present?
      User.find_as account_type, email: session[:user]
    elsif cookies[:rememberme]
      cookie_parts = cookies[:rememberme].split('|')
      if user = User.find(cookie_parts.first)
        session[:user] = user.email if cookie_parts[1] == user.auth_token
        session[:role] = user.type
      end
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
    return redirect_to '/' unless signed_in?
  end

  def forbid_authenticated!
    return redirect_to '/' if signed_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    render text: "Forbidden on an ACL", status: :forbidden
  end

  protected

  def include_current_user
    if request.format.html?
      gon.rabl template: 'app/views/users/show.json', locals: { user: current_user }, as: :current_user
    end
  end

  def sign_user_in user, options={}
    return false if user.type == :specialist && !user.can_login

    session[:user] = user.email
    session[:role] = options[:as] if options[:as].present?
    user.tap do |u|
      u.last_login_at = Time.now
      u.generate_auth_token
    end.save validate: false
    user.generate_cookie { |cookie| cookies[:rememberme] = cookie } if params[:rememberme]
    @current_user = user

    signed_in?
  end

  def account_type;   @account_type ||= session[:role].try :to_sym end
  def is_employer?;   account_type == :employer end
  def is_specialist?; account_type == :specialist end

  def setup_account_data
    if is_employer?
      gon.push \
        user:           current_user,
        company:        current_account,
        keyword_groups: KeywordGroup.all,
        industries:     Industry.all,
        areas:          Area.all,
        searches:       current_user.searches,
        folders:        current_user.folders,
        locations:      Location.order(name: :desc).pluck(:name)
    elsif is_specialist?
      gon.statuses = Hash[Specialist::STATUSES.map { |s| [s, I18n.t("user.status.#{s}")] }]
    end
  end

end
