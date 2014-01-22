class MakingBlacklistSearchSpecific < ActiveRecord::Migration

  def change
    add_column :searches, :blacklisted, :string, array: true, default: []
    drop_table :entries_blacklists do |t|
      t.belongs_to :user
      t.string :entries, array: true
    end
  end

end
