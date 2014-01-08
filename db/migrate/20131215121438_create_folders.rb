class CreateFolders < ActiveRecord::Migration

  def change
    create_table :searches do |t|
      t.string :name
      t.string :query
      t.belongs_to :user
    end

    create_table :folders do |t|
      t.string :name
      t.belongs_to :user
    end

    create_table :entries_folders, id: false do |t|
      t.integer :entry_id, null: false
      t.integer :folder_id, null: false
    end
    add_index :entries_folders, [:entry_id, :folder_id], unique: true
  end

end
