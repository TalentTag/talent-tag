class ChangeEntryLocationName < ActiveRecord::Migration
  def change
    rename_column :entries, :location, :profile_location
  end
end
