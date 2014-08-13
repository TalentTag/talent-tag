class UsersController < ApplicationController

  respond_to :json


  def create
    @user = User.new create_params
    if @user.save
      sign_user_in @user, as: params[:type]
      respond_with @user, status: :created
    else
      respond_with @user, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, current_user
    current_user.update_attributes(update_params)
    respond_with current_user
  end

  def signin
    user = User.find_by! id: params[:id]
    authorize! :signin_as, user
    session[:prev_user] = session[:user]
    sign_user_in(user)
    redirect_to account_path
  end

  def add_company
    if User.find_by!(email: params[:email]).send_company_adding_notification
      flash[:notice] = "Инструкции высланы на указанный адрес"
      render nothing: true, status: :no_content
    end
  end

  def create_company
    @user = User.find_by!(id: params[:user_id])
    @company = Company.new(name: params[:company][:name])
    @company.owner_id = @user.id
    if @company.save
      @user.update role: :owner, company_id: @company.id
      sign_user_in @user, as: :employer
      redirect_to account_path
    else
      render 'public/add_company'
    end
  end


  private

  def create_params
    params.require(:user).permit :email, :password, :password_confirmation
  end

  def update_params
    params.require(:user).permit :firstname, :lastname, :phone
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
