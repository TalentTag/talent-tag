object @folder
attributes :id, :name
child :entries do
  attributes :id, :body, :source_id, :url, :author, :created_at
end
