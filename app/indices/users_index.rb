ThinkingSphinx::Index.define :user, with: :active_record do
  indexes tags
  where "status <> 'ignore'"
end
