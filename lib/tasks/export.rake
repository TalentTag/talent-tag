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
      end.to_a.map { |item| csv << item }
    end
  end

end
