environment 'production'
pidfile 'tmp/pids/puma.pid'
bind 'unix:///var/www/talenttag/shared/sockets/puma.sock'
stdout_redirect 'log/puma.access.log', 'log/puma.error.log', true
daemonize

threads 4, 32
workers 3
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
preload_app!
