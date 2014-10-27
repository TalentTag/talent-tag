class AddPortfolio < ActiveRecord::Migration

  def change
    create_table :portfolio do |t|
      t.belongs_to :user
      t.string :title, null: false
      t.string :href, null: false
      t.timestamp :created_at, null: false
    end
  end

end
