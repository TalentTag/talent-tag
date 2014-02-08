class PremiumAccounts < ActiveRecord::Migration

  def up
    add_column :companies, :status, :integer, null: false, default: Company::TYPE_DEFAULT
    add_column :companies, :premium_since, :date
    change_column :companies, :created_at, :timestamp, null: false
  end

  def down
    remove_column :companies, :status
    remove_column :companies, :premium_since
    change_column :companies, :created_at, :date, null: false
  end

end
