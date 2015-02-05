class Locaitions < ActiveRecord::Migration

  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :synonyms, null: false, array: true
    end
    add_column :entries, :location_id, :integer
  end

end
