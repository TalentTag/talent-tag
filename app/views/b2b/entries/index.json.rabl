collection @entries

attributes :id, :body, :source_id, :created_at, :fetched_at, :user_id, :location
attribute :url #if can?(:read, :premium_data)
node(:excerpt) { |entry| entry.excerpts.body if entry.respond_to? :excerpts }
node(:duplicates_count) { |entry| entry.duplicates.count }
node(:author) do |entry|
  if entry.user_id.present?
    partial("/users/show", object: entry.user)
  else
    {
      name: (entry.author['profile']['name'] rescue nil),
      avatar: (entry.author['profile']['photo'] rescue nil)
    }
  end
end
