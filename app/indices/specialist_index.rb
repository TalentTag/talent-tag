ThinkingSphinx::Index.define :specialist, with: :active_record do
  indexes tags
  indexes profile_location

  has created_at, location_id
end
