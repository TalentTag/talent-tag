class UpdateDefaultUserStatus < ActiveRecord::Migration

  def up
    change_column :users, :status, :string, default: Specialist::STATUSES.last
  end

  def down
    change_column :users, :status, :string, default: Specialist::STATUSES.first
  end

end
