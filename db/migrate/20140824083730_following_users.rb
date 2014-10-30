class FollowingUsers < ActiveRecord::Migration

  def change
    create_table :followings do |t|
      t.belongs_to :user
      t.integer :following_id, null: false
    end
    add_index :followings, :user_id
  end

end
