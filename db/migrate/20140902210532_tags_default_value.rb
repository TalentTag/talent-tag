class TagsDefaultValue < ActiveRecord::Migration

  def up
    execute "ALTER TABLE users ALTER COLUMN tags SET DEFAULT '{}'"
  end

  def down
    change_column :users, :tags, :string, array: true
  end

end
