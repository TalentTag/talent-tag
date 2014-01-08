class AccountController < ApplicationController

  before_action :require_authentication!, except: %i(signup signup_employee)
  before_action :forbid_authenticated!, only: %i(signup signup_employee)


  def index
    return render :unconfirmed unless current_account.confirmed?
    gon.push \
      keyword_groups: KeywordGroup.all,
      industries:     Industry.all,
      areas:          Area.all,
      searches:       current_user.searches,
      folders:        current_user.folders
  end

  def update_user
    if current_user.update_attributes(user_params)
      sign_user_in(current_user)
      flash.now[:notice] = "Данные обновлены"
    end
    render :profile
  end

  def company
    authorize! :read, current_account
  end

  def update_account
    authorize! :update, current_account
    if current_account.update_attributes(company_params)
      flash.now[:notice] = "Данные обновлены"
    end
    render :company
  end

  def employee
    authorize! :invite, User
  end

  def add_employee
    authorize! :invite, User
    if current_account.invites.create(email: params[:email])
      flash.now[:notice] = "Уведомление отправлено на #{ params[:email] }"
    end
    render :employee
  end


  def remove_employee
    user = current_account.users.find params[:id]
    authorize! :destroy, user
    flash.now[:notice] = "Пользователь удален из системы" if user.delete
    redirect_to account_employee_path
  end


  private

  def user_params
    params.require(:user).permit(:email, :firstname, :midname, :lastname, :phone, :password, :password_confirmation)
  end

  def company_params
    params.require(:company).permit(:name, :website, :phone, :address, :details)
  end

end
