class CompaniesController < ApplicationController

  respond_to :json
  after_action :sign_user_in, only: :create


  def create
    authorize! :create, Company
    company = Company.new create_params
    if company.save
      @user = company.owner
      redirect_to account_path
    else
      respond_with company, status: :unprocessable_entity
    end
  end

  def update
    if current_account.update_attributes(update_params)
      Proposal.find_or_initialize_by(company_id: current_account.id).tap { |p| p.status = Proposal::STATUSES.first }.save if current_account.detailed?
      respond_with current_account
    else
      render json: current_account.errors.messages, status: :unprocessable_entity
    end
  end


  private

  def create_params
    params.require(:company).permit(:name, owner_attributes: [:email, :password, :password_confirmation])
  end
  
  def update_params
    params.require(:company).permit(:website, :phone, :address, :details)
  end

end
