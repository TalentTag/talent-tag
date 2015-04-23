TalentTag::Application.config.secret_key_base = if Rails.env.development?
  'sometoken'
else
  ENV["secret_key_base"]
end
