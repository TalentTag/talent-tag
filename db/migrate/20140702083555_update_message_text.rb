class UpdateMessageText < ActiveRecord::Migration

  def change
    change_column :messages, :text, :text, null: false
  end

end
