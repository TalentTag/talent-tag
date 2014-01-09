object @folder
attributes :id, :name
node(:entry_ids) { |folder| folder.entries }
child :details do
  attributes :id, :body, :source_id, :url, :author, :created_at
end
