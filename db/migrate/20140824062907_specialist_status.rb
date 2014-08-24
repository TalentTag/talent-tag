class SpecialistStatus < ActiveRecord::Migration

  def change
    add_column :users, :status, :string, default: User::STATUSES.first
  end

end
