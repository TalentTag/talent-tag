class AddFiltersToQuery < ActiveRecord::Migration

  def change
  	add_column :queries, :filters, :json, default: {}
  end

end
