server "188.226.157.222", :web, :app, :db, primary: true

set :branch,  :development
set :user,    "deploy"

set :rails_env,       :production
set :unicorn_rack_env, :production

set :repository,      "git@github.com:TalentTag/talent-tag.git"