class ConversationsRefactor < ActiveRecord::Migration

  def up
    drop_table :conversations_users

    Conversation.destroy_all

    add_column :conversations, :user_id, :integer, null: false
    add_column :conversations, :specialist_id, :integer, null: false
    add_column :conversations, :last_activity, :json, default: {}

    add_column :messages, :source, :string, null: false
  end

  def down
    create_table :conversations_users do |t|
      t.references :conversation, index: true
      t.references :user, index: true
      t.datetime :last_activity_at
    end

    remove_column :conversations, :user_id
    remove_column :conversations, :specialist_id
    remove_column :conversations, :last_activity

    remove_column :messages, :source
  end

end
