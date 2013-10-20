class UsersController < ApplicationController

  respond_to :json


  def update
    current_user.update_attributes(update_params)
    respond_with current_user
  end


  private

  def update_params
    params.require(:user).permit :firstname, :midname, :lastname, :phone
  end

end
