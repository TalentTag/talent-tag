class DenormalizingComments < ActiveRecord::Migration

  def up
    add_column :comments, :company_id, :integer
    add_index :comments, :company_id

    Comment.all.each do |comment|
      comment.update company_id: comment.user.company.id
    end

    change_column :comments, :company_id, :integer, null: false
    remove_index :comments, [:user_id, :entry_id]
  end


  def down
    remove_column :comments, :company_id
    add_index :comments, [:user_id, :entry_id], unique: true
  end

end
