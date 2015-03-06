server "178.62.200.27", :web, :app, :db, primary: true

set :branch,  :development
set :user,    "rbdev"

set :rails_env,       :staging
set :unicorn_rack_env, :staging
