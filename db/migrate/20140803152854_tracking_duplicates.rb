class TrackingDuplicates < ActiveRecord::Migration

  def change
    add_column :entries, :duplicate_of, :integer
  end

end
