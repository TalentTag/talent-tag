# server "178.62.229.126", :web, :app, :db, primary: true

server "178.62.200.27", :web, :app, :db, primary: true

set :branch,  :search_fix
set :user,    "rbdev"

set :rails_env,       :staging
set :unicorn_rack_env, :staging

set :repository,      "git@github.com:flowerett/talent-tag.git"