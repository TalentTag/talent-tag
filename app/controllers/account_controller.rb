class AccountController < ApplicationController

  before_action :require_authentication!, except: %i(index signup signup_employee)
  before_action :forbid_authenticated!, only: %i(signup signup_employee)
  before_action :setup_account_data, only: :index


  def index
    return render 'public/promo' unless signed_in?
    if is_employer?
      # return render 'b2b/blocked' if current_account.blocked?
      render 'b2b/account'
    elsif is_specialist?
      @user = current_user
      @owns_account = true
      gon.portfolio = current_user.portfolio.load
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
    if params[:status].in? Specialist::STATUSES
      current_user.status = params[:status]
      current_user.save validate: false
      render nothing: true, status: :no_content
    else
      render nothing: true, status: :bad_request
    end
  end

  def following
    @users = current_user.follows.includes('following').map &:following
    gon.rabl template: 'app/views/users/index.json', as: :users
    render 'b2b/following/index'
  end

end
