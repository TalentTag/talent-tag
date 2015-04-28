class SearchLastCheck < ActiveRecord::Migration

  def change
    add_column :searches, :last_checked_at, :timestamp
  end

end
