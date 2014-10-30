class B2b::SearchesController < B2b::BaseController

  respond_to :json
  before_action :require_authentication!


  def create
    respond_with current_user.searches.create name: params[:query], query: params[:query]
  end

  def update
    respond_with current_user.searches.find_by!(id: params[:id]).update name: params[:name]
  end

  def destroy
    respond_with current_user.searches.destroy params[:id]
  end

  def blacklist
    Search.find_by!(id: params[:id]).blacklist! Entry.find_by!(id: params[:entry_id])
    render nothing: true, status: :no_content
  end

end
