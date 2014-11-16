namespace :danthes do

  task :start do
    system "rackup danthes.ru -s puma -E production"
  end

end
