require "bundler/capistrano"

server "188.226.157.222", :web, :app, :db, primary: true

set :application,     "talenttag"
set :deploy_to,       "/var/www/#{application}"

set :rails_env,       :production
set :bundle_without,  [:development, :test]
set :use_sudo,        false
set :keep_releases, 3

set :scm,             :git
set :repository,      "git@github.com:artshpakov/talent.git"
set :branch,          :development
set :user,            "artshpakov"

set :default_environment, {
  'PATH' => '/usr/local/rvm/gems/ruby-2.1.0:/usr/local/rvm/gems/ruby-2.1.0/bin:/usr/local/rvm/rubies/ruby-2.1.0/bin:$PATH'
}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"


after "deploy:update", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Restart Unicorn"
  task :restart, roles: :app, except: { no_release: true } do
    unicorn.restart
  end
end

namespace :unicorn do
  desc "Start Unicorn"
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_path}; unicorn -D -E #{rails_env} -c #{current_path}/config/unicorn.rb"
  end

  desc "Stop Unicorn"
  task :stop, roles: :app, except: { no_release: true } do
    run "kill $(cat #{current_path}/tmp/pids/unicorn.pid)"
  end

  desc "Restart Unicorn"
  task :restart, roles: :app, except: { no_release: true } do
    stop
    start
  end
end
