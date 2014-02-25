object @entry
attributes :id, :body, :source_id, :created_at, :fetched_at, :author
attribute :url if can?(:read, :premium_data)
node(:excerpt) { |entry| entry.excerpts.body }
code :comment do |entry|
  (@comments || entry.comments).find { |c| c.entry_id == entry.id }.try :attributes
end
