class CreateUsers < ActiveRecord::Migration

  def change
    create_table :companies do |t|
      t.string      :name, limit: 30, null: false
      t.integer     :owner_id

      t.string      :website, limit: 40
      t.string      :phone, limit: 20
      t.string      :address
      t.string      :details

      t.date        :confirmed_at
      t.date        :created_at, null: false
    end

    create_table :users do |t|
      t.string      :email, null: false, limit: 60
      t.string      :password_digest, null: false
      t.belongs_to  :company

      t.string      :firstname, limit: 30
      t.string      :midname, limit: 30
      t.string      :lastname, limit: 30
      t.string      :phone, limit: 20
      t.string      :note

      t.string      :forgot_token
      t.string      :auth_token
      t.date        :created_at, null: false
    end


    add_index :companies, :name
    add_index :users, :email, unique: true
  end

end
