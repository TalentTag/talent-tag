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
    redis.sadd "notifications:#{ author_id }", self
  end

  def self.create attrs
    new(attrs.merge created_at: Time.now).save
  end

  def self.where authors
    Array.wrap(authors).flat_map do |author|
      id = if author.kind_of?(User) then author.id else author end
      redis.smembers("notifications:#{ id }").map { |n| new JSON.parse n }
    end.sort_by { |n| n.created_at }.reverse
  end


  private

  def redis
    self.class.redis
  end

  def self.redis
    TalentTag::Application::Redis
  end

end
