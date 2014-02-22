class B2c::AccountController < B2c::BaseController

  before_action :require_authentication!

end
