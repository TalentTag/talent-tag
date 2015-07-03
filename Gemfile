source 'https://rubygems.org'

# == Asset Components
source 'https://rails-assets.org' do
  gem 'rails-assets-ngInfiniteScroll', '~> 1.1.2'
  gem 'rails-assets-angular', '~> 1.2.28', require: false
end

# == Core
gem 'rails', '4.0.13'
# gem 'rails', '4.2.3'

# == DB
gem 'pg'
gem 'squeel'
gem 'mysql2' # thinking-sphinx dependency
gem 'thinking-sphinx', '~> 3.1.4' # '~> 3.1.3'
gem 'postgres_ext'

# == View
gem 'slim-rails'
gem 'gon'
gem 'redcarpet'
gem 'gravatar_image_tag'

# == JSON
gem 'rabl'
gem 'yajl-ruby'

# == Struct
gem 'kaminari'
gem 'aasm'

# == Auth
gem 'bcrypt-ruby', '3.1.2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin'
gem 'cancan'

# == BG & Websockets
gem 'faye'
gem 'danthes'
gem 'redis-rails'
gem 'sidekiq'
gem 'whenever', require: false

# == Assets
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

gem 'anjlab-bootstrap-rails', '~> 3.0.0.3', require: 'bootstrap-rails'
# deprecated, use:
# gem 'bootstrap-sass', '~> 3.3.5'
# gem 'sass-rails', '>= 3.2'

gem 'role-rails'
gem 'maskedinput-rails'
gem 'momentjs-rails'
gem 'underscore-rails'
gem 'angularjs-rails', '~> 1.2.0'
gem 'angular-ui-bootstrap-rails'
gem 'angular_rails_csrf'
gem 'font-awesome-rails'
gem 'i18n-js'


gem 'figaro'
gem 'pry-rails'
gem 'russian'

gem 'newrelic_rpm'

gem 'unicorn', group: :production
gem 'thin'

group :development do
  gem 'capistrano', '~> 2.15.0'
  gem 'capistrano-multistage'
  gem 'capistrano-unicorn', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'rack-mini-profiler'
  gem 'letter_opener'
  gem 'binding_of_caller'
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
end

gem "faye-redis"
