class SpecialistsTable < ActiveRecord::Migration

  def up
    create_table :specialists do |t|
      t.string   :email,  limit: 60,  null: false
      t.string   :password_digest, null: false
      t.string   :firstname, limit: 30
      t.string   :lastname, limit: 30
      t.json     :profile, default: {}
      t.string   :status, default: :passive
      t.string   :tags, default: [], array: true
      t.string   :role
      t.string   :forgot_token
      t.string   :auth_token
      t.datetime :last_login_at
      t.date     :created_at, null: false
    end
    
    add_index :specialists, :email, unique: true

    # copy specialist entries from 'users' to 'specialists'
    select_all("SELECT * FROM users").each do |user_hash|
      specialist_attributes = user_hash.select { |attr, value| Specialist.new.has_attribute? attr }.reject { |k,v| k=='id' || v.nil? }
      execute "INSERT INTO specialists(#{ specialist_attributes.keys.join(',') }) VALUES (#{ specialist_attributes.values.map { |v| "'#{v}'" }.join(',') })"
    end

    # recalculate identity-specialist relations
    Identity.find_each do |identity|
      email   = User.find(identity.user_id).email
      new_id  = Specialist.where(email: email).first.id
      identity.update user_id: new_id
    end

    # nullify entry-specialist relations
    Entry.update_all user_id: nil

    # clear things up
    remove_column :users, :status
    remove_column :users, :tags
    User.where(role: nil).delete_all
  end


  def down
    drop_table :specialists
    add_column :users, :status, :string
    add_column :users, :tags, :string, array: true
  end

end
