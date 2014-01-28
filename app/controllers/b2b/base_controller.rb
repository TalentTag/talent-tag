class B2b::BaseController < ApplicationController

  layout 'b2b'

  before_action :b2b_users_only!


  protected

  def fetch_account_data
    gon.push \
      keyword_groups: KeywordGroup.all,
      industries:     Industry.all,
      areas:          Area.all,
      searches:       current_user.searches,
      folders:        current_user.folders
  end


  protected

  def b2b_users_only!
    authorize! :manage, :b2b
  end

end
