app_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

worker_processes 4
working_directory app_root
listen 'unix:/tmp/basic.sock', backlog: 512
timeout 120
pid "/var/run/unicorn/unicorn.pid"
stderr_path "#{app_root}/log/unicorn.error.log"
