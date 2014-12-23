class RenamingFollowings < ActiveRecord::Migration

  def up
    create_table :specialists_users do |t|
      t.belongs_to :user
      t.belongs_to :specialist
    end
    add_index :specialists_users, :user_id

    drop_table :followings
  end

  def down
    create_table :followings do |t|
      t.belongs_to :user
      t.integer :following_id, null: false
    end
    add_index :followings, :user_id

    drop_table :specialists_users
  end

end
