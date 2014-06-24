class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :plan_id
      t.integer :payer_id
      t.integer :price
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :payer_country
      t.string :company
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.datetime :confirmed_at
      t.datetime :completed_at
      t.datetime :canceled_at
      t.datetime :failed_at
      t.string :token

      t.timestamps
    end
  end
end
