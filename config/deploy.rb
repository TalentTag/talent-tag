require "bundler/capistrano"

set :application,     "talenttag"
set :deploy_to,       "/var/www/#{application}"

set :stages,          %w(production staging)
set :default_stage,   "staging"
require 'capistrano/ext/multistage'

set :rails_env,       :production
set :bundle_without,  [:development, :test]
set :use_sudo,        false
set :keep_releases, 3

set :scm,             :git
set :repository,      "git@github.com:TalentTag/talent-tag.git"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :symlinks, %w(config/database.yml config/thinking_sphinx.yml config/danthes.yml)
set :dir_symlinks, %w(log db/sphinx)

set :whenever_command, "bundle exec whenever"

require "whenever/capistrano"
require 'thinking_sphinx/capistrano'
require 'capistrano-unicorn'

after "deploy:finalize_update", "deploy:make_symlinks:"
after "deploy:update", "deploy:migrate"

after 'deploy:assets:precompile', 'deploy:assets:export_i18n'

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Creates additional symlinks for the shared configs."
  task :make_symlinks, :roles => :app, :except => { :no_release => true } do
    fetch(:dir_symlinks, []).each do |path|
      run "mkdir -p #{shared_path}/#{path}"
      run "rm -rf #{release_path}/#{path} && ln -nfs #{shared_path}/#{path} #{release_path}/#{path}"
    end

    fetch(:symlinks, []).map do |path|
      run "mkdir -p #{shared_path}/#{path.gsub(/([^\/]*)$/, '')}"
      run "if [ -f #{release_path}/#{path}.example ]; then yes n | cp -i #{release_path}/#{path}.example #{shared_path}/#{path}; fi;"
      run "rm -rf #{release_path}/#{path} && ln -nfs #{shared_path}/#{path} #{release_path}/#{path}"
    end

    %w(pids sockets).each do |dir|
      run "mkdir -p #{shared_path}/#{dir}"
      run "rm -rf #{release_path}/tmp/#{dir} && ln -nfs #{shared_path}/#{dir} #{release_path}/tmp/#{dir}"
    end
  end

  namespace :assets do
    desc "Export translations into a JS file"
    task :export_i18n, :roles => :app do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake i18n:js:export"
    end
  end
end

namespace :admin do
  desc "Tail production log files."
  task :tail_logs, :roles => :app do
    invoke_command "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}" if stream == :out
      warn "[err :: #{channel[:server]}] #{data}" if stream == :err
    end
  end
end
