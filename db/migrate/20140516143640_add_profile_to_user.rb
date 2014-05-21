class AddProfileToUser < ActiveRecord::Migration

  def change
    add_column :users, :profile, :json, default: {}
  end

end
