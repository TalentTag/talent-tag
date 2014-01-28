class Admin::EntriesController < Admin::BaseController

  def index
    @entries = Entry.page 1
    gon.sources = Source.all
    gon.total_pages = @entries.num_pages
    # @TODO: skip comments
    gon.rabl template: "app/views/b2b/entries/index.json", as: :entries
  end
    
end
