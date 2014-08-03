ThinkingSphinx::Index.define :entry, with: :active_record do
  indexes body
  has :id, source_id, user_id, created_at, duplicate_of
end
