class DenormalizingFolders < ActiveRecord::Migration

  def up
    add_column :folders, :entries, :string, array: true, default: []
    drop_table :entries_folders
  end


  def down
    remove_column :folders, :entries

    create_table :entries_folders, id: false do |t|
      t.integer :entry_id, null: false
      t.integer :folder_id, null: false
    end
    add_index :entries_folders, [:entry_id, :folder_id], unique: true
  end

end
