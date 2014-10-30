class UpdateDefaultUserStatus < ActiveRecord::Migration

  def up
    change_column :users, :status, :string, default: User::STATUSES.last
  end

  def down
    change_column :users, :status, :string, default: User::STATUSES.first
  end

end
