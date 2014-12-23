class User < ActiveRecord::Base

  include UserConcern


  belongs_to :company
  has_and_belongs_to_many :follows, class_name: 'Specialist'
  has_many :searches, foreign_key: :user_id, dependent: :destroy
  has_many :folders, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id
  has_one :blacklist, foreign_key: :user_id, class_name: 'EntriesBlacklist'

  after_create :send_signup_notification


  def type() :employer end

  def self.find_as type, params
    case type
      when :employer
        User.find_by params
      when :specialist
        Specialist.find_by params
    end
  end


  def post_comment entry, text
    comments.create entry_id: entry.id, text: text
  end


  def follows? user
    id = user.kind_of?(Specialist) ? user.id : user
    !!follows.where(id: id).exists?
  end

  def follow! user
    specialist = user.kind_of?(Specialist) ? user : Specialist.find(user)
    follows.push specialist
  end

  def unfollow! user
    specialist = user.kind_of?(Specialist) ? user : Specialist.find(user)
    follows.delete specialist
  end


  def send_signup_notification
    # AuthMailer.send("signup_#{ role || "default" }", self).deliver unless role.nil?
  end

  def send_company_adding_notification
    generate_auth_token!
    AuthMailer.add_company(self).deliver
  end

  def notify
    # Notification.create author_id: id, event: "status_change", data: status if status_changed?
  end

end
