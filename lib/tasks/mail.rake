namespace :mail do

  desc "Send custom search updates"
  task searches: :environment do
    User.where("settings->>'search'=?", true).find_each do |user|
      MailUpdatesWorker.perform_async user
    end
  end

end
