class CreateDictionaries < ActiveRecord::Migration

  def change
    create_table :industries do |t|
      t.string :name
    end

    create_table :areas do |t|
      t.string :name
    end

    create_table :keyword_groups do |t|
      t.string :keywords, array: true
      t.belongs_to :industry
      t.belongs_to :area
    end
  end

end
