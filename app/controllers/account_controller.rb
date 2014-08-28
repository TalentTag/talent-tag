class AccountController < ApplicationController

  before_action :require_authentication!, except: %i(index signup signup_employee)
  before_action :forbid_authenticated!, only: %i(signup signup_employee)

  def index
    return render 'public/promo' unless signed_in?
    if is_employer?
      fetch_account_data
      return render 'b2b/blocked' if current_account.blocked?
      render 'b2b/account'
    elsif is_specialist?
      @user = current_user
      gon.statuses = Hash[User::STATUSES.map { |s| [s, I18n.t("user.status.#{s}")] }] # TODO move to a decorator
      render 'b2c/account'
    else
      render text: "Error 403", status: :forbidden # TODO raise a 403 exception
    end
  end

  def update
    current_user.update profile: params[:data]
    render nothing: true, status: :no_content
  end

  def update_status
    current_user.update status: params[:status]
    render nothing: true, status: :no_content
  end

end
