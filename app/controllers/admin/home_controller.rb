class Admin::HomeController < Admin::BaseController

  def dictionaries
    gon.push \
      industries:     Industry.all,
      areas:          Area.all,
      keyword_groups: KeywordGroup.all
  end

end
