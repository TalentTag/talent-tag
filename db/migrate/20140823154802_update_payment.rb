class UpdatePayment < ActiveRecord::Migration

  def change
    rename_column :payments, :user_id, :company_id
    remove_column :payments, :price, :string
    remove_column :payments, :firstname, :string
    remove_column :payments, :middlename, :string
    remove_column :payments, :lastname, :string
    remove_column :payments, :company, :string
    remove_column :payments, :address1, :string
    remove_column :payments, :address2, :string
    remove_column :payments, :city, :string
    remove_column :payments, :payer_country, :string
  end

end
