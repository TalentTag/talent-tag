object @entry
attributes :id, :body, :source_id, :created_at, :fetched_at, :author
attribute :url if can?(:read, :premium_data)
node :comment do |entry|
  (@comments || entry.comments).find { |c| c.entry_id == entry.id }.try :attributes
end
node :profile_id do |entry|
  Identity.find_by(anchor: entry.author['guid']).user.id rescue nil # TODO move to decorator
end
