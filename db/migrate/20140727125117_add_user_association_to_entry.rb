class AddUserAssociationToEntry < ActiveRecord::Migration

  def change
    add_column :entries, :user_id, :integer
    add_index :entries, :user_id

    Entry.all.each do |entry|
      entry.update user_id: entry.user.id if entry.user
    end
  end

end
