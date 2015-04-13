class AddIndexToKeywordGroups < ActiveRecord::Migration
  def change
    add_index  :keyword_groups, :keywords, using: 'gin'
  end
end
