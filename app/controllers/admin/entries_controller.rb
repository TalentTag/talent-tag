class Admin::EntriesController < Admin::BaseController

  before_action { authorize! :update, Entry }

  def index
    gon.sources = Source.all
  end

  def deleted
    @entries = Entry.marked.limit(30)
  end

  def delete
    Entry.find_by!(id: params[:id]).delete!
    redirect_to :deleted_admin_entries
  end

  def restore
    Entry.find_by!(id: params[:id]).restore!
    redirect_to :deleted_admin_entries
  end
    
end
