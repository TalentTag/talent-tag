class CreateEntries < ActiveRecord::Migration

  def change
    create_table :sources, id: false do |t|
      t.integer :id, null: false
      t.string :name, null: false
      t.string :url
      t.boolean :hidden, default: false
    end
    add_index :sources, :id, unique: true

    create_table :entries, id: false do |t|
      t.integer :id, null: false
      t.text :body, null: false
      t.belongs_to :source
      t.string :url
      t.timestamp :created_at, null: false
    end
    add_index :entries, :id, unique: true
    add_index :entries, :source_id
  end

end
