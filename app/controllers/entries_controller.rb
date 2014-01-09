class EntriesController < ApplicationController

  respond_to :json

  before_action :require_authentication!
  skip_before_filter :verify_authenticity_token, only: %i(destroy blacklist)


  def index
    @entries = Entry.filter params.merge published: true, user: current_user
    response.headers["TT-Pagecount"] = @entries.num_pages.to_s
  end

  def destroy
    authorize! :destroy, Entry
    respond_with Entry.find_by!(id: params[:id]).destroy
  end

  def show
    @entry = Entry.find_by! id: params[:id]
  end

  def blacklist
    Entry.find_by!(id: params[:id]).blacklist_by current_user
    render nothing: true, status: :no_content
  end

end
