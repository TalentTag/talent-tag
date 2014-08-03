class TrackingDuplicates < ActiveRecord::Migration

  def change
    add_column :entries, :duplicate_of, :integer

    Entry.all.each do |entry|
      original = Entry.where("body='#{entry.body}' AND id!=#{entry.id}").order(:created_at).limit(1).try :first
      entry.update duplicate_of: original.id if original and original.duplicate_of.nil?
    end
  end

end
