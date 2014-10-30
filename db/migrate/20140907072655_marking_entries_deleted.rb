class MarkingEntriesDeleted < ActiveRecord::Migration

  def change
    add_column :entries, :state, :string, default: :normal
  end

end
