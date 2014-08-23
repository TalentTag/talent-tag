class Admin::HomeController < Admin::BaseController

  def dictionaries
    authorize! :update, :dictionaries
    gon.push \
      industries:     Industry.all,
      areas:          Area.all,
      keyword_groups: KeywordGroup.all
  end

end
