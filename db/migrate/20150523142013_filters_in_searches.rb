class FiltersInSearches < ActiveRecord::Migration

  def change
    add_column :searches, :filters, :json, default: {}
  end

end
