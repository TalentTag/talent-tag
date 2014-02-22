class B2b::EntriesController < B2b::BaseController

  respond_to :json

  before_action :require_authentication!


  def index
    if params[:folder_id]
      @entries = current_user.folders.find_by!(id: params[:folder_id]).details
    elsif params[:search_id]
      search = Search.find_by!(id: params[:search_id])
      @entries = Entry.filter(params.merge query: search.query, published: true, blacklist: search.blacklisted)
      response.headers["TT-entriestotal"] = @entries.total_count.to_s
    elsif params[:query]
      @entries = Entry.filter(params.merge published: true)
      response.headers["TT-entriestotal"] = @entries.total_count.to_s
    else
      @entries = Entry.filter params # @TODO check pagination
    end
    @comments = Comment.where(entry_id: @entries.map(&:id), user_id: current_user.id)
  end


  def destroy
    authorize! :destroy, Entry
    respond_with Entry.find_by!(id: params[:id]).destroy
  end


  def show
    authorize! :read, Entry
    respond_to do |format|
      format.html do
        fetch_account_data
        render 'b2b/account/index', layout: 'b2b'
      end
      format.json { @entry = Entry.find_by! id: params[:id] }
    end
  end

end
