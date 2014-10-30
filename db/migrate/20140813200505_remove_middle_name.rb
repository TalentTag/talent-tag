class RemoveMiddleName < ActiveRecord::Migration

  def change
    remove_column :users, :midname
  end

end
