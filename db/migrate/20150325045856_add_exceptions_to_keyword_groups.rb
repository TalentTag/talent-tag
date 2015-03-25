class AddExceptionsToKeywordGroups < ActiveRecord::Migration
  def change
    add_column :keyword_groups, :exceptions, :string, array: true
    add_index  :keyword_groups, :exceptions, using: 'gin'
  end
end
