class AccountController < ApplicationController

  before_action :require_authentication!, except: %i(signup signup_employee)
  before_action :forbid_authenticated!, only: %i(signup signup_employee)


  def update_user
    if current_user.update_attributes(user_params)
      sign_user_in(current_user)
      flash.now[:notice] = "Данные обновлены"
    end
    render :profile
  end

  def update_account
    authorize! :update, current_account
    if current_account.update_attributes(company_params)
      flash.now[:notice] = "Данные обновлены"
    end
    render :company
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
    authorize! :delete, user
    flash.now[:notice] = "Пользователь удален из системы" if user.delete
    render :employee
  end


  private

  def user_params
    params.require(:user).permit(:email, :firstname, :midname, :lastname, :phone, :password, :password_confirmation)
  end

  def company_params
    params.require(:company).permit(:name, :website, :phone, :address, :details)
  end

end
