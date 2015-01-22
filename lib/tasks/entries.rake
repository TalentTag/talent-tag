namespace :entries do

  desc "Updated marked as deleted entries to 'deleted'"
  task trash: :environment do
    Entry.marked.update_all state: 'deleted'
  end

end
