require 'csv'

namespace :export do

  def entries
    Source.find(63225).entries
  end

  task vk: :environment do
    CSV.open "#{ Rails.root }/tmp/vk.csv", "w" do |csv|
      {}.tap do |data|
        entries.each do |entry|
          begin
            id = entry.author['guid'].split('/').last
            data[id] = entry.created_at.strftime("%d.%m.%Y") unless data[id]
          rescue
            p "Error in #{entry.id}" 
          end
        end
      end.to_a.each { |item| csv << item }
    end
  end


  task geo: :environment do
    CSV.open "#{ Rails.root }/tmp/geo.csv", "w" do |csv|
      locations = []
      Specialist.find_each do |user|
        locations << user.profile['location'] rescue nil
      end
      Entry.find_each do |entry|
        locations << entry.author['profile']['city'] rescue nil
      end
      locations.compact!
      {}.tap do |hash|
        locations.each { |location| hash[location] = (hash[location] || 0) + 1 }
      end.to_a.sort.each { |item| csv << item }
    end
  end

end
