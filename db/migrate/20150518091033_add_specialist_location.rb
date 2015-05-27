class AddSpecialistLocation < ActiveRecord::Migration
  def change
    add_column :specialists, :profile_location, :string

    add_index :specialists, :profile_location, using: :gist
  end
end
