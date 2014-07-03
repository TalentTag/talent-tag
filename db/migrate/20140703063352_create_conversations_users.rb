class CreateConversationsUsers < ActiveRecord::Migration
  def change
    create_table :conversations_users do |t|
      t.references :conversation, index: true
      t.references :user, index: true
      t.datetime :last_activity_at
    end
  end
end
