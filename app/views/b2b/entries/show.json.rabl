object @entry
attributes :id, :body, :source_id, :url, :created_at, :author
code :comment do |entry|
  (@comments || entry.comments).find { |c| c.entry_id == entry.id }.try :attributes
end
