desc "Start Unicorn"
task :start, :environment do |t, args|
  env = args[:environment] || :production
  sh "unicorn -D -E #{env} -c config/unicorn.rb"
  puts "    Unicorn started in #{env} mode"
end


desc "Stop Unicorn"
task :stop do
  config_path = "#{Rails.root}/config/unicorn.rb"
  begin
    pid_path = File.read(config_path).scan(/pid \"(.*)\"/)[0][0]
    pid = File.read(pid_path).to_i
    sh "kill #{pid}"
    puts "    Unicorn shut down"
  rescue
  end
end


desc "Restart Unicorn"
task :restart, :environment do |t, args|
  env = args[:environment] || :production
  Rake::Task[:stop].invoke env
  Rake::Task[:start].invoke env
end
