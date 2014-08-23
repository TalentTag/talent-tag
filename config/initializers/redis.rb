redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env].symbolize_keys
TalentTag::Application::Redis = Redis.new redis_config
