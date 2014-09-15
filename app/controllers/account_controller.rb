class AccountController < ApplicationController

  before_action :require_authentication!, except: %i(index signup signup_employee)
  before_action :forbid_authenticated!, only: %i(signup signup_employee)
  before_action :setup_account_data, only: :index


  def index
    return render 'public/promo' unless signed_in?
    if is_employer?
      return render 'b2b/blocked' if current_account.blocked?
      render 'b2b/account'
    elsif is_specialist?
      @user = current_user
      @owns_account = true
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


  protected

  def setup_account_data
    if is_employer?
      gon.push \
        user:           current_user,
        company:        current_account,
        keyword_groups: KeywordGroup.all,
        industries:     Industry.all,
        areas:          Area.all,
        searches:       current_user.searches,
        folders:        current_user.folders
    else
      gon.statuses = Hash[User::STATUSES.map { |s| [s, I18n.t("user.status.#{s}")] }]
    end
  end


end
