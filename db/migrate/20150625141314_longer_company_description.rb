class LongerCompanyDescription < ActiveRecord::Migration

  def up
    change_column :companies, :details, :text
  end

  def down
  	change_column :companies, :details, :string
  end

end
