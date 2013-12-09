class EmbeddedProfiles < ActiveRecord::Migration

  def self.up
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
    add_column :entries, :author, :json
  end

  def self.down
    remove_column :entries, :author
    execute "DROP EXTENSION IF EXISTS hstore"
  end

end
