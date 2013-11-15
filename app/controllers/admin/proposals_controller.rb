class Admin::ProposalsController < Admin::BaseController

  respond_to :json


  def index
    @proposals = Proposal.awaiting
  end

  def show
    @proposal = Proposal.find_by! id: params[:id], status: :awaiting
    @company = @proposal.company
  end

  def update
    respond_with Proposal.find(params[:id]).update update_params
  end


  private

  def update_params
    params.require(:proposal).permit(:status, :note)
  end

end
