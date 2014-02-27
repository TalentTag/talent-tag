class B2b::EntriesController < B2b::BaseController

  respond_to :json

  before_action :require_authentication!


  def index
    @entries = if params[:folder_id]
      current_user.folders.find_by!(id: params[:folder_id]).details
    elsif params[:search_id]
      search = Search.find_by!(id: params[:search_id])
      Entry.filter(params.merge query: search.query, published: true, blacklist: search.blacklisted)
    elsif params[:query]
      Entry.filter(params.merge published: true)
    else
      Entry.filter params
    end
    @comments = Comment.where(entry_id: @entries.map(&:id), user_id: current_user.id)
    response.headers["TT-entriestotal"] = @entries.total_count.to_s if @entries.respond_to? :total_count
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
        render 'b2b/account/index'
      end
      format.json { @entry = Entry.find_by! id: params[:id] }
    end
  end

end
