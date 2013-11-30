class EntriesController < ApplicationController

  def index
    @entries = Entry.filter params
    response.headers["TT-Pagecount"] = @entries.num_pages.to_s
  end

end
