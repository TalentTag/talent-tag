class Admin::EntriesController < Admin::BaseController

  before_action { authorize! :update, Entry }

  def index
    @year    = params[:year].try(:to_i)  || Date.today.year
    @month   = params[:month].try(:to_i) || Date.today.month
    @page    = params[:page].try(:to_i)  || 1
    @entries = Entry.within(@year, @month).page(@page)
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
