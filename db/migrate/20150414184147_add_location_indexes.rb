class AddLocationIndexes < ActiveRecord::Migration
  def change
    enable_extension :btree_gist
    enable_extension :pg_trgm

    add_index :entries, :location, using: :gist
  end
end
