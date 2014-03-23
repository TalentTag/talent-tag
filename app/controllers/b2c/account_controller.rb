class B2c::AccountController < B2c::BaseController

  before_action :require_authentication!

  helper_method :journal


  def current
    @user = current_user
    render :show
  end

  def show
    @user = User.find_by! id: params[:id]
  end


  protected

  def journal
    unless @user.identities.empty?
      condition = @user.identities.map { |id| "(author->>'guid' = '#{ id.anchor }')" }.join(' OR ')
      Entry.where(condition).includes(:source).order(created_at: :desc).references(:source)
    end || []
  end

end
