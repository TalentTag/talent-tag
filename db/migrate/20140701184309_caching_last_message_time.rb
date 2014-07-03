class CachingLastMessageTime < ActiveRecord::Migration

  def change
    add_column :conversations, :last_message_at, :timestamp
  end

end
