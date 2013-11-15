class CreateProposals < ActiveRecord::Migration

  def change
    create_table :proposals do |t|
      t.belongs_to :company
      t.string :status, limit: 10, default: :awaiting
      t.string :note
      t.timestamp :created_at, null: false
    end
  end

end
