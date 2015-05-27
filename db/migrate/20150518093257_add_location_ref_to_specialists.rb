class AddLocationRefToSpecialists < ActiveRecord::Migration
  def change
    add_reference :specialists, :location, index: true, foreign_key: true
  end
end
