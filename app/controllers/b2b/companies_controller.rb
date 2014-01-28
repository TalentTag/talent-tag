class B2b::CompaniesController < B2b::BaseController

  respond_to :json

  skip_before_filter :b2b_users_only!, only: :create


  def create
    company = Company.new create_params
    if company.save
      sign_user_in company.owner, skip_validation: true
      respond_with company
    else
      respond_with company, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, current_account
    if current_account.update_attributes(update_params)
      Proposal.find_or_initialize_by(company_id: current_account.id).tap { |p| p.status = Proposal::STATUSES.first }.save if current_account.detailed?
      respond_with current_account
    else
      render json: current_account.errors.messages, status: :unprocessable_entity
    end
  end


  private

  def create_params
    params[:company][:owner_attributes].update role: :owner
    params.require(:company).permit(:name, owner_attributes: [:email, :password, :password_confirmation, :role])
  end
  
  def update_params
    params.require(:company).permit(:website, :phone, :address, :details)
  end

end
