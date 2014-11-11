collection @entries

attributes :id, :body, :source_id, :created_at, :fetched_at, :author, :user_id, :location
attribute :url if can?(:read, :premium_data)
node(:excerpt) { |entry| entry.excerpts.body if entry.respond_to? :excerpts }
node(:duplicates_count) { |entry| entry.duplicates.count }
