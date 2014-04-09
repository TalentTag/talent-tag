class B2b::BaseController < ApplicationController

  before_action :b2b_users_only!


  protected

  def b2b_users_only!
    render nothing: true, status: :forbidden unless can?(:manage, :b2b) && is_employer?
  end

end
