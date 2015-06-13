class SpecialistUpdated < ActiveRecord::Migration

  def change
  	add_column :specialists, :changed_at, :timestamp, null: false, default: Time.now
  end

end
