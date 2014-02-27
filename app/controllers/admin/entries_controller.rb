class Admin::EntriesController < Admin::BaseController

  def index
    gon.sources = Source.all
  end
    
end
