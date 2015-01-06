class AddNotifications < ActiveRecord::Migration

  def change
    create_table :notifications do |t|
      t.string :source, null: false
      t.integer :author_id, null: false
      t.string :event, null: false
      t.json :data
      t.timestamp :created_at, null: false
    end
    add_index :notifications, %i(source author_id)
  end

end
