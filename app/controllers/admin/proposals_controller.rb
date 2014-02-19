class Admin::ProposalsController < Admin::BaseController

  def index
    @proposals = Proposal.awaiting
  end

  def show
    @proposal = Proposal.find_by! id: params[:id], status: :awaiting
    @company = @proposal.company
  end

  def update
    Proposal.find(params[:id]).update(update_params)
    flash.notice = "Статус заявки изменен"
    render nothing: true, status: :no_content
  end


  private

  def update_params
    params.require(:proposal).permit(:status, :note)
  end

end
