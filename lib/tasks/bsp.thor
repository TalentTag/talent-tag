class Bsp < Thor

  desc "fetch", "fetch data from remote server"
  method_option :date, aliases: "-d", desc: "Specify a date in a YYYY-MM-DD format, today is default"
  def fetch
    require 'open-uri'
    require 'json'
    require File.expand_path("config/environment.rb")

    started_at = Time.now
    total_entries_fetched = if options[:date] then fetch_by_date(Date.strptime options[:date]) else fetch_recent end
    puts "\n#{ Time.now.strftime("%d.%m.%Y %H:%M %Z") }: #{ total_entries_fetched } entries stored in #{ (Time.now - started_at).to_i } seconds\n"

    system "rake ts:index > /dev/null" unless total_entries_fetched.zero?
  end


  private

  def fetch_recent
    request_and_parse "http://api.brandspotter.ru/clients/1071/words.json?api_key=ubx260cagzy287shpdjk935ntr2jl0cr"
  end

  def fetch_by_date date
    url   = "http://api.brandspotter.ru/clients/1071/words.json?filters[fromdate]=#{ date.strftime("%Y-%m-%d") }&filters[todate]=#{ (date+1).strftime("%Y-%m-%d") }&api_key=ubx260cagzy287shpdjk935ntr2jl0cr"
    total = JSON.parse(open("#{ url }&pagesize=1").read)['meta']['total']
    pages = (total.to_f/10).ceil
    (0..pages-1).reduce(0) do |sum, page|
      sum + request_and_parse("#{ url }&page=#{ page }")
    end
  end


  def request_and_parse url
    saved_entries = 0
    data          = JSON.parse open(url).read

    data['entries'].each do |entry|
      source = entry['platform']
      Source.create(id: source['id'], name: source['name'], url: source['url'])
    end

    data['entries'].map do |entry|
      if source = (entry['platform']['id'] rescue nil) && Source.find_by(id: entry['platform']['id'])
        entry = source.entries.new id: entry['id'], body: entry['body'].gsub(/<\/?[^>]*>/, ""), url: entry['url'], author: entry['author'], created_at: entry['created_at'], fetched_at: Time.now
        if entry.valid? && entry.save
          saved_entries += 1
          print '.'
        end
      end
    end

    saved_entries
  end

end
