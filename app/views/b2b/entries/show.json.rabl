object @entry
attributes :id, :body, :source_id, :created_at, :fetched_at, :author, :user_id
attribute :url if can?(:read, :premium_data)
node :comment do |entry|
  (@comments || entry.comments).find { |c| c.entry_id == entry.id }.try :attributes
end
