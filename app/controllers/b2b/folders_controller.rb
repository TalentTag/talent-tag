class B2b::FoldersController < B2b::BaseController

  respond_to :json
  before_action :require_authentication!
  before_action :find_folder, only: %i(update add_entry remove_entry)


  def show
    fetch_account_data
    render 'account/b2b'
  end

  def create
    respond_with current_user.folders.create name: params[:name]
  end

  def update
    respond_with @folder.update name: params[:name]
  end

  def add_entry
    respond_with @folder.add params[:entry_id]
  end

  def remove_entry
    respond_with @folder.reject params[:entry_id]
  end

  def destroy
    respond_with Folder.where(user: current_user).delete(params[:id])
  end


  private

  def find_folder
    @folder = current_user.folders.find_by! id: params[:id]
  end

end
