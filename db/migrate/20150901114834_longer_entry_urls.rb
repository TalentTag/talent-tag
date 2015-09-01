class LongerEntryUrls < ActiveRecord::Migration

  def change
    change_column :entries, :url, :string, limit: 500
  end

end
