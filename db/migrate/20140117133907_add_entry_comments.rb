class AddEntryComments < ActiveRecord::Migration

  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :entry
      t.text :text, null: false
      t.timestamp :created_at
    end
    add_index :comments, [:user_id, :entry_id], unique: true
  end

end
