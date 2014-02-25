class MemorizingEntryFetchingTime < ActiveRecord::Migration

  def change
    add_column :entries, :fetched_at, :timestamp, null: false
  end

end
