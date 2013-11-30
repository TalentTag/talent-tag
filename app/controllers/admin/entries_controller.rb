class Admin::EntriesController < Admin::BaseController

  def index
    @entries = Entry.page 1
    gon.sources = Source.all
    gon.total_pages = @entries.num_pages
    gon.rabl "app/views/entries/index.json.rabl", as: :entries
  end
    
end
