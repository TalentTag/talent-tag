class AccountController < ApplicationController

  before_action :require_authentication!

end
