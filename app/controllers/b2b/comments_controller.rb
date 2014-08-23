class B2b::CommentsController < B2b::BaseController

  respond_to :json
  before_action :fetch_entry


  def create
    @comment = current_user.post_comment(@entry, params[:text])
    render :show
  end

  def update
    comment = Comment.find_by!(id: params[:id])
    authorize! :update, comment
    respond_with @entry, comment.update(text: params[:text])
  end

  def destroy
    respond_with current_user.comments.destroy(params[:id]), status: :no_content
  end


  private

  def fetch_entry
    @entry = Entry.find params[:entry_id]
  end

end
