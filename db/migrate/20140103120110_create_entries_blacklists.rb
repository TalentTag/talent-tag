class CreateEntriesBlacklists < ActiveRecord::Migration

  def change
    create_table :entries_blacklists do |t|
      t.belongs_to :user
      t.string :entries, array: true
    end
  end

end
