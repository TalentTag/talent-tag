class PremiumAccounts < ActiveRecord::Migration

  def up
    add_column :companies, :premium_since, :timestamp
    add_column :companies, :premium_until, :timestamp
    change_column :companies, :created_at, :timestamp, null: false
  end

  def down
    remove_column :companies, :premium_since
    remove_column :companies, :premium_until
    change_column :companies, :created_at, :date, null: false
  end

end
