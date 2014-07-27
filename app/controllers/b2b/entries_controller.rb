class B2b::EntriesController < B2b::BaseController

  respond_to :json

  before_action :require_authentication!
  skip_before_filter :b2b_users_only!, only: :create


  def index
    @entries = if params[:folder_id]
      current_user.folders.find_by!(id: params[:folder_id]).details
    elsif params[:search_id]
      search = Search.find_by!(id: params[:search_id])
      query = if search.query==params[:query] then search.query else "(#{ search.query }) && (#{ params[:query] })" end
      Entry.filter(params.merge query: query, published: true, blacklist: search.blacklisted)
    elsif params[:query]
      Entry.filter(params.merge published: true)
    else
      Entry.filter params
    end
    @comments = Comment.where(entry_id: @entries.map(&:id), user_id: current_user.id)
    response.headers["TT-entriestotal"] = @entries.total_count.to_s rescue nil
  end


  def create
    authorize! :create, Entry

    tt_entries_count = Entry.where(source_id: nil).count
    Entry.create create_params.merge fetched_at: Time.now, id: tt_entries_count+1, author: build_author_data

    return render text: nil
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
        render 'account/b2b'
      end
      format.json { @entry = Entry.find_by! id: params[:id] }
    end
  end


  private

  def create_params
    params.require(:entry).permit(:body)
  end

  def build_author_data
    {
      guid: "tt-#{ current_user.id }",
      name: current_user.name
    }
  end

end
