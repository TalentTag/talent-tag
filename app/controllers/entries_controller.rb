class EntriesController < ApplicationController

  respond_to :json

  before_action :require_authentication!
  skip_before_filter :verify_authenticity_token, only: %i(destroy blacklist)


  def index
    if params[:folder_id]
      @entries = current_user.folders.find_by!(id: params[:folder_id]).details
    else
      @entries = if params[:search_id] then filter_by_search else filter_by_keywords end
      response.headers["TT-Pagecount"] = @entries.num_pages.to_s
    end
    @comments = Comment.where(entry_id: @entries.map(&:id), user_id: current_user.id)
  end

  def destroy
    authorize! :destroy, Entry
    respond_with Entry.find_by!(id: params[:id]).destroy
  end

  def show
    return redirect_to account_path unless current_account.confirmed?
    respond_to do |format|
      format.html do
        fetch_account_data
        render 'account/index'
      end
      format.json { @entry = Entry.find_by! id: params[:id] }
    end
  end


  protected

  def filter_by_keywords
    Entry.filter params.merge published: true    
  end

  def filter_by_search
    search = Search.find_by!(id: params[:search_id])
    Entry.filter query: search.query, published: true, blacklist: search.blacklisted
  end

end
