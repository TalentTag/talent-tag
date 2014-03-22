class AddAnchorToIdentity < ActiveRecord::Migration

  def change
    add_column :identities, :anchor, :string, limit: 70
  end

end
