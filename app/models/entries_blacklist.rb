class EntriesBlacklist < ActiveRecord::Base

  belongs_to :user

  def fetch
    Entry.where id: entries
  end

  def add entry
    self.entries = [] if entries.nil?
    entries_will_change!
    entries << entry.id
    save
  end

end
