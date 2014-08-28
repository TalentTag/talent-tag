class ExtractingTagsOutOfProfile < ActiveRecord::Migration

  def change
    add_column :users, :tags, :string, array: true
  end

end
