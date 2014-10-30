class CreateIdentities < ActiveRecord::Migration

  def change
    create_table :identities do |t|
      t.belongs_to :user
      t.string :provider, null: false
      t.string :uid, null: false
      t.timestamp :created_at
    end

    add_index :identities, :user_id
    add_index :identities, [:provider, :uid], unique: true
  end

end
