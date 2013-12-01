set :output, "#{path}/log/cron.log"

job_type :thor, "cd #{path}; bundle exec thor :task :output"

every 10.minutes do
  thor "bsp:fetch"
end
