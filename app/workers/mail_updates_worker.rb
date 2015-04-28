class MailUpdatesWorker

  include Sidekiq::Worker

  def perform user
    searches = Search.where(user_id: user['id'])
    updates = {}
    searches.each do |search|
      count = Entry.search_for_ids(search.query, without: { source_id: Source.unpublished }, with: { fetched_at: search.last_checked_at..Time.now }).total_count
      updates[search.name] = count unless count.zero?
    end
    UpdatesMailer.new_entries(user['email'], updates).deliver if updates.present?
  end

end
