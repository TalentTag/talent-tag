class AddSocialNetworksToCompany < ActiveRecord::Migration

  def change
    add_column :companies, :social, :json, default: {}
  end

end
