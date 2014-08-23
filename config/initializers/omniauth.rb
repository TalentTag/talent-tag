Rails.application.config.middleware.use OmniAuth::Builder do
  config = YAML.load_file("#{Rails.root}/config/omniauth.yml")[Rails.env].symbolize_keys

  config.each do |provider, params|
    provider provider, params['app_id'], params['app_secret'], scope: (params['scope'] || nil)
  end

  TalentTag::Application::PROVIDERS = config
end
