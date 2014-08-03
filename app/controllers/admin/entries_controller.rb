class Admin::EntriesController < Admin::BaseController

  before_action { authorize! :update, Entry }

  def index
    gon.sources = Source.all
  end
    
end
