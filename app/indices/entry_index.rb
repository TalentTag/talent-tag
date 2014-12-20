ThinkingSphinx::Index.define :entry, with: :active_record do
  indexes body
  has source_id, user_id, created_at, duplicate_of
  where "state = 'normal'"
end
