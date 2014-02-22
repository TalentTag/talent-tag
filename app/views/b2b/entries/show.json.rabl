object @entry
attributes :id, :body, :source_id, :created_at, :author
attribute :url if can? :read, :premium_data
code :comment do |entry|
  (@comments || entry.comments).find { |c| c.entry_id == entry.id }.try :attributes
end
