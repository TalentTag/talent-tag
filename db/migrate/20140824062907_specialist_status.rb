class SpecialistStatus < ActiveRecord::Migration

  def change
    add_column :users, :status, :string, default: Specialist::STATUSES.first
  end

end
