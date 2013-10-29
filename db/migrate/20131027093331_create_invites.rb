class CreateInvites < ActiveRecord::Migration

  def change
    create_table :invites do |t|
      t.string :code, null: false
      t.string :email, null: false
      t.belongs_to :company, null: false
    end
  end

end
