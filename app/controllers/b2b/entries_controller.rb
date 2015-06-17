class B2b::EntriesController < B2b::BaseController

  respond_to :json

  before_action :require_authentication!
  skip_before_filter :b2b_users_only!, only: :create


  def index
    @entries = if params[:folder_id]
      current_user.folders.find_by!(id: params[:folder_id]).details
    elsif params[:search_id]
      search = Search.find_by!(id: params[:search_id])
      entries = Entry.filter(params.merge(search.filters).merge query: search.query, published: true, blacklist: search.blacklisted)
      response.headers["TT-entriestotal"] = entries.total_count.to_s rescue nil
      blacklist = search.blacklisted.map &:to_i
      search.touch!
      entries.reject { |e| e.id.in? blacklist }
    elsif params[:query]
      Query.create(user_id: current_user.id, text: params[:query], filters: {location: params[:location].presence})
      entries = Entry.filter(params.merge published: true)
      response.headers["TT-entriestotal"] = entries.total_count.to_s rescue nil
      entries
    else
      Entry.filter params
    end
  end


  def create
    authorize! :create, Entry
    id = Entry.unscoped.order(id: :desc).find_by(source_id: nil).id+1 rescue 1
    Entry.create body: params[:body], fetched_at: Time.now, id: id, author: build_author_data, user_id: current_user.id
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
