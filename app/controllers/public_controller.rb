class PublicController < ApplicationController

  before_action :find_user_by_forgot_token, only: %i(edit_password update_password)
  before_action :find_user_by_auth_token, only: %i(add_company create_company)
  before_action :find_invite, only: %i(add_employee create_employee)


  def update_password
    if @user.update_password! password_params
      # sign_user_in @user, as: :employer
      redirect_to account_path, flash: { notice: "Пароль изменен, вы можете использовать его для входа в систему" }
    else
      render :edit_password
    end
  end

  def create_employee
    if @user = @invite.company.users.create(password_params.merge(email: @invite.email, role: :employee))
      @invite.delete
      sign_user_in @user, as: :employer
      redirect_to account_path
    end
  end

  def create_company
    if @user.company.create(name: params[:company][:name])
      sign_user_in @user, as: :employer
      redirect_to account_path
    else
      render text: "Invalid"
    end
  end

  def excerpts
    @entries = Entry.search params[:q]
    @entries.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
  end


  private

  def find_user_by_forgot_token
    @user = User.find_by! forgot_token: params[:token]
  end

  def find_user_by_auth_token
    @user = User.find_by! auth_token: params[:token]
  end

  def find_invite
    @invite = Invite.find_by! code: params[:code], company_id: params[:company_id]
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
