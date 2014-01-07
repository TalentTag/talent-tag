class AddUsersLoginTime < ActiveRecord::Migration

  def change
    add_column :users, :last_login_at, :timestamp
  end

end
