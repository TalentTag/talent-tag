class RawIdentityData < ActiveRecord::Migration

  def change
    add_column :identities, :raw_data, :json
  end

end
