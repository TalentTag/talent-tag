require "bundler/capistrano"

server "216.119.148.53", :web, :app, :db, primary: true

set :application,     "talenttag"
set :deploy_to,       "/var/www/#{application}"

set :rails_env,       :production
set :bundle_without,  [:development, :test]
set :use_sudo,        false
set :keep_releases, 3

set :scm,             :git
set :repository,      "git@github.com:artshpakov/talent.git"
set :branch,          :master

set :default_environment, {
  'PATH' => '/usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/rubies/ruby-2.0.0-p247/bin:$PATH'
}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy:update", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Start Unicorn"
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_path}; bundle exec rake start[#{rails_env}]"
  end

  desc "Stop Unicorn"
  task :stop, roles: :app, except: { no_release: true } do
    run "cd #{current_path}; bundle exec rake stop"
  end

  desc "Restart Unicorn"
  task :restart, roles: :app, except: { no_release: true } do
    run "cd #{current_path}; bundle exec rake restart[#{rails_env}]"
  end
end
