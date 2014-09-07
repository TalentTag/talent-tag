class Notification
  include ActiveModel::Model

  attr_accessor :author_id, :event, :created_at, :data


  def initialize params={}
    params.each do |field, value|
      method = "#{ field }="
      public_send(method, value) if respond_to?(method)
    end
  end

  def to_s() to_json end

  def author
    User.find author_id
  end

  def save
    KeyValue.setex "notifications:#{ author_id }:#{ Time.now.to_i }", 7.days, self
  end

  def self.create attrs
    new(attrs.merge created_at: Time.now).save
  end

  def self.where authors, last_check=nil
    last_check ||= 7.days.ago
    Array.wrap(authors).flat_map do |author|
      id = if author.kind_of?(User) then author.id else author end
      KeyValue.keys("notifications:#{ id }:*").map do |key|
        timestamp_of_creation = key.split(':').last
        new JSON.parse KeyValue.get(key) if timestamp_of_creation.to_i > last_check.to_i
      end.compact
    end.sort_by { |n| n.created_at }.reverse
  end

end
