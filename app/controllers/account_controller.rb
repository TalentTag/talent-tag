class AccountController < ApplicationController

  before_action :require_authentication!, except: %i(index signup signup_employee)
  before_action :forbid_authenticated!, only: %i(signup signup_employee)

  helper_method :journal


  def index
    return render 'public/promo' unless signed_in?
    if is_employer?
      fetch_account_data
      return render :blocked if current_account.blocked?
      render 'account/b2b'
    elsif is_specialist?
      @user = current_user
      render 'account/b2c'
    else
      render text: "Error 403", status: :forbidden # TODO raise a 403 exception
    end
  end


  protected

  def journal # TODO export to a decorator
    unless @user.identities.empty?
      condition = @user.identities.map { |id| "(author->>'guid' = '#{ id.anchor }')" }.join(' OR ')
      Entry.where(condition).includes(:source).order(created_at: :desc).references(:source)
    end || []
  end

end
