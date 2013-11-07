class Admin::BaseController < ApplicationController

  layout 'admin'
  before_filter :require_authentication!
  before_filter do
    authorize! :manage, :admin unless Rails.env.development?
  end

end
