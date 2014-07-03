class CreateMessages < ActiveRecord::Migration

  def change
    create_table :conversations do |t|
      t.integer :participants, array: true
    end

    create_table :messages do |t|
      t.belongs_to :conversation
      t.integer :user_id, null: false
      t.string :text, null: false
      t.timestamp :created_at
    end
  end

end
