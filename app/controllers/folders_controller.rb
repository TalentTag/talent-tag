class FoldersController < ApplicationController

  respond_to :json

  before_action :require_authentication!
  before_action :find_folder, only: %i(show update add_entry remove_entry)
  skip_before_filter :verify_authenticity_token, only: %i(create update add_entry remove_entry destroy)


  def show
    respond_to do |format|
      format.html do
        fetch_account_data
        render 'account/index'
      end
      format.json { respond_with @folder }
    end
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
