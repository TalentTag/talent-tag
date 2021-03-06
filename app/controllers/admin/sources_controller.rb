class Admin::SourcesController < Admin::BaseController

  respond_to :json

  before_action { authorize! :update, Source }


  def index
    gon.sources = Source.all
  end

  def update
    respond_with Source.find_by!(id: params[:id]).update update_params
  end


  private

  def update_params
    params.require(:source).permit(:hidden)
  end

end
