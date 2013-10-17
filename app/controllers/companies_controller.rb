class CompaniesController < ApplicationController

  respond_to :json
  after_action :sign_user_in, only: :create


  def create
    company = Company.new create_params
    if company.save
      @user = company.owner
      redirect_to account_path
    else
      respond_with company, status: :unprocessable_entity
    end
  end


  private

  def create_params
    params.require(:company).permit(:name, owner_attributes: [:email, :password, :password_confirmation])
  end

end
