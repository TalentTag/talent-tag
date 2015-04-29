class HiddenController < ApplicationController

  def account
    gon.push \
      keyword_groups: KeywordGroup.all,
      industries:     Industry.all,
      areas:          Area.all,
      searches:       current_user.searches,
      folders:        current_user.folders,
      locations:      Location.order(name: :desc).pluck(:name)
  end

end
