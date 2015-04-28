class MailUpdatesWorker

  include Sidekiq::Worker

  def perform user
    searches = Search.where(user_id: user['id'])
    updates = {}
    searches.each do |search|
      updates[search.name] = new_entries_count unless new_entries_count.zero?
    end
    UpdatesMailer.new_entries(user['email'], updates).deliver if updates.present?
  end

end
