class EntryLocations < ActiveRecord::Migration

  def change
    add_column :entries, :location, :string, limit: 100
  end

end
