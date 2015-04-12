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
      entries = Entry.filter(params.merge query: query, published: true, blacklist: search.blacklisted)
      blacklist = search.blacklisted.map &:to_i
      entries.reject { |e| e.id.in? blacklist }
    elsif params[:query]
      Query.create(user_id: current_user.id, text: params[:query])
      Entry.filter(params.merge published: true)
    else
      Entry.filter params
    end
    response.headers["TT-entriestotal"] = @entries.total_count.to_s rescue nil
  end


  def create
    authorize! :create, Entry
    tt_entries_count = Entry.where(source_id: nil).count
    Entry.create body: params[:body], fetched_at: Time.now, id: tt_entries_count+1, author: build_author_data, user_id: current_user.id
    return render text: nil
  end


  def destroy
    authorize! :destroy, Entry
    Entry.find_by!(id: params[:id]).mark_as_deleted!
    render nothing: true, status: :no_content
  end


  def show
    authorize! :read, Entry
    respond_to do |format|
      format.html do
        setup_account_data
        render 'b2b/account'
      end
      format.json { @entry = Entry.find_by! id: params[:id] }
    end
  end


  private

  def build_author_data
    {
      guid: "tt-#{ current_user.id }",
      name: current_user.name
    }
  end

end
