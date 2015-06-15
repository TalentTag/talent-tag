class LongerCompanyName < ActiveRecord::Migration

  def change
  	change_column :companies, :name, :string, null: false, limit: 100
  end

end
