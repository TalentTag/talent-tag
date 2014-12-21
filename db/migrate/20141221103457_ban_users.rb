class BanUsers < ActiveRecord::Migration

  def change
    add_column :specialists, :can_login, :boolean, default: true
  end

end
