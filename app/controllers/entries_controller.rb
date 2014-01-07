class EntriesController < ApplicationController

  respond_to :json

  skip_before_filter :verify_authenticity_token, only: :destroy


  def index
    @entries = Entry.filter params
    response.headers["TT-Pagecount"] = @entries.num_pages.to_s
  end

  def destroy
    authorize! :destroy, Entry
    respond_with Entry.find_by!(id: params[:id]).destroy
  end

end
