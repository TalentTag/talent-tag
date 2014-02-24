object @entry
attributes :id, :body, :source_id, :created_at, :author, :url
code :comment do |entry|
  (@comments || entry.comments).find { |c| c.entry_id == entry.id }.try :attributes
end
