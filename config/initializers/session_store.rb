TalentTag::Application.config.session_store :cookie_store,
  key:      '_TalentTag_session',
  domain:   ('.talent-tag.ru' if Rails.env.in? %w(production staging))
