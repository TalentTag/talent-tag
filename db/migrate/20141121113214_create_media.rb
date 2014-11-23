class CreateMedia < ActiveRecord::Migration

  def change
    create_table :media do |t|
      t.string :title, null: false
      t.string :source, null: false
      t.string :link, null: false
      t.date :published_at
      t.string :tags, array: true
    end
  end

end
