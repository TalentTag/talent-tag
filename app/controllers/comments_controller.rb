class CommentsController < ApplicationController

  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_action :fetch_entry


  def create
    respond_with @entry, current_user.post_comment(@entry, params[:text])
  end

  def update
    comment = Comment.find_by!(id: params[:id])
    authorize! :update, comment
    respond_with @entry, comment.update(text: params[:text])
  end


  private

  def fetch_entry
    @entry = Entry.find params[:entry_id]
  end

end
