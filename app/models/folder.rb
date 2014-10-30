class Folder < ActiveRecord::Base

  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }


  def entries
    super.map { |id| id.try :to_i }
  end

  def details
    Entry.find entries
  end


  def add entry_id
    entries_will_change!
    self.entries = entries << entry_id.to_i
    save
  end

  def reject entry_id
    entries_will_change!
    self.entries = entries.delete_if { |a| a == entry_id }
    save
  end

end
