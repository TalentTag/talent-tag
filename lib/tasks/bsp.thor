class Bsp < Thor

  desc "fetch", "fetch data from remote server"
  def fetch
    require 'open-uri'
    require 'json'
    require File.expand_path("config/environment.rb")

    data = JSON.parse open("http://bspv2-app1.sterno.ru:8081/clients/1071/words.json?api_key=ubx260cagzy287shpdjk935ntr2jl0cr").read

    data['entries'].each do |entry|
      source = entry['platform']
      Source.new(id: source['id'], name: source['name'], url: source['url']).tap do |s|
        print '.' if s.save
      end
    end
    puts "\n"

    data['entries'].each do |entry|
      if source = (entry['platform']['id'] rescue nil) && Source.find_by(id: entry['platform']['id'])
        entry = source.entries.new id: entry['id'], body: entry['body'], url: entry['url'], author: entry['author']
        if entry.valid?
          entry.save
          print '.'
        end
      end
    end
    puts "\n"

    system "rake ts:index"
  end

end
