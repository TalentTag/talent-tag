class Admin::EntriesController < Admin::BaseController

  before_action { authorize! :update, Entry }

  def index
    @year    = params[:year].try(:to_i)  || Date.today.year
    @month   = params[:month].try(:to_i) || Date.today.month
    @day     = params[:day].try(:to_i)   || Date.today.day
    @date    = Date.new @year, @month, @day
    @entries = Entry.visible.within(@date)
    @entries = @entries.from_published_sources if params[:published].present?
  end

  def deleted
    @entries = Entry.marked.limit(30)
  end

  def delete
    Entry.find_by!(id: params[:id]).delete!
    render nothing: true, status: :no_content
  end

  def restore
    Entry.find_by!(id: params[:id]).restore!
    redirect_to :deleted_admin_entries
  end
    
end
