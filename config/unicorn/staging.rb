app_path = "/var/www/talenttag/current"
pid_file   = "#{app_path}/tmp/pids/unicorn.pid"
sock_file = "#{app_path}/tmp/sockets/unicorn.sock"
log_file   = "#{app_path}/log/unicorn.log"
err_log    = "#{app_path}/log/unicorn_error.log"

worker_processes   1
preload_app        true
timeout            30
listen             sock_file, :backlog => 1024

working_directory  app_path
pid                pid_file
stderr_path        err_log
stdout_path        log_file

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end