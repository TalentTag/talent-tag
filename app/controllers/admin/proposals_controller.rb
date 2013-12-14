class Admin::ProposalsController < Admin::BaseController

  skip_before_filter :verify_authenticity_token, only: :update


  def index
    @proposals = Proposal.awaiting
  end

  def show
    @proposal = Proposal.find_by! id: params[:id], status: :awaiting
    @company = @proposal.company
  end

  def update
    Proposal.find(params[:id]).update(update_params)
    redirect_to admin_proposals_path, notice: "Статус заявки изменен"
  end


  private

  def update_params
    params.require(:proposal).permit(:status, :note)
  end

end
