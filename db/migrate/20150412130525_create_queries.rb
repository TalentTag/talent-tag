class CreateQueries < ActiveRecord::Migration

  def change
    create_table :queries do |t|
      t.string :text, null: false
      t.belongs_to :user
      t.timestamp :created_at
    end
  end

end
