class B2c::AccountController < B2c::BaseController

  before_action :require_authentication!


  def index
    @entries = unless current_user.identities.empty?
      condition = current_user.identities.map { |id| "(author->>'guid' = '#{ id.anchor }')" }.join(' OR ')
      Entry.where(condition).includes(:source).order(created_at: :desc).references(:source)
    end || []
  end

end
