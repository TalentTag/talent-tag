ThinkingSphinx::Index.define :specialist, with: :active_record do
  indexes tags
  has created_at
end
