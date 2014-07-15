redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env].symbolize_keys

TalentTag::Application.config.session_store :redis_store,
  servers:    [ host: redis_config[:host], port: redis_config[:port] ],
  key:        'tt_session',
  expire_in:  2.weeks,
  domain:     ('.talent-tag.ru' if Rails.env.production?)
