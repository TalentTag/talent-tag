set :output, "#{path}/log/cron.log"

job_type :thor, "cd #{path}; :environment_variable=:environment bundle exec thor :task :output"

every 3.minutes do
  thor "bsp:fetch"
end

every 1.day, at: "7:12 pm" do
  thor "bsp:fetch -d today"
end

every 1.day, at: "9:30 pm" do
  rake "mail:searches"
end
