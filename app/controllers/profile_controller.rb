class ProfileController < ApplicationController

  def update_user
    if current_user.update_attributes(user_params)
      sign_user_in(current_user)
      flash.now[:notice] = "Данные обновлены"
    end
    render :user
  end

  def update_avatar
    current_user.profile.merge! 'image_source' => params[:user][:avatar_type], 'image' => params[:user][:avatar]
    current_user.profile_will_change!
    flash.now[:notice] = "Данные обновлены" if current_user.save validate: false
    render :user
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
    redirect_to profile_employee_path
  end

  def remove_employee
    user = current_account.users.find params[:id]
    authorize! :destroy, user
    flash.now[:notice] = "Пользователь удален из системы" if user.delete
    redirect_to profile_employee_path
  end


  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :midname, :lastname, :phone, :password, :password_confirmation)
  end

  def company_params
    params.require(:company).permit(:name, :website, :phone, :address, :details)
  end

end
