ThinkingSphinx::Index.define :entry, with: :active_record do
  indexes body
  indexes location

  has source_id, user_id, created_at, fetched_at, duplicate_of, location_id

  where "state = 'normal'"
end
