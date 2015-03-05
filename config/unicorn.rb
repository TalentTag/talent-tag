# === update config
app_path = "/var/www/talenttag/current"
pid_file   = "#{app_path}/tmp/pids/unicorn.pid"
log_file   = "#{app_path}/log/unicorn.log"
err_log    = "#{app_path}/log/unicorn_error.log"

worker_processes   1
preload_app        true
timeout            30
listen             '127.0.0.1:9021'
user               'rbdev', 'rbdev'
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
# ===

# app_path = "/var/www/talenttag/current"

# log_file   = "#{app_path}/log/unicorn.log"
# err_log    = "#{app_path}/log/unicorn_error.log"
# pid_file   = "#{app_path}/tmp/pids/unicorn.pid"
# sock_file = "#{app_path}/tmp/sockets/unicorn.sock"
# old_pid = "#{pid_file}.oldbin"

# rails_env = ENV['RAILS_ENV'] || 'production'

# worker_processes (rails_env == 'production' ? 4 : 1)

# preload_app true

# timeout 30

# listen sock_file, :backlog => 2048

# pid pid_file
# stderr_path err_log
# stdout_path log_file

# if GC.respond_to?(:copy_on_write_friendly=)
#   GC.copy_on_write_friendly = true
# end


# before_fork do |server, worker|
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end


# after_fork do |server, worker|
#   ActiveRecord::Base.establish_connection

#   begin
#     uid, gid = Process.euid, Process.egid
#     user, group = 'deploy', 'deploy'
#     target_uid = Etc.getpwnam(user).uid
#     target_gid = Etc.getgrnam(group).gid
#     worker.tmp.chown(target_uid, target_gid)
#     if uid != target_uid || gid != target_gid
#       Process.initgroups(user, target_gid)
#       Process::GID.change_privilege(target_gid)
#       Process::UID.change_privilege(target_uid)
#     end
#   rescue => e
#     if rails_env == 'development'
#       STDERR.puts "couldn't change user, oh well"
#     else
#       raise e
#     end
#   end
# end
