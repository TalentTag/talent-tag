class User < ActiveRecord::Base

  include UserConcern


  belongs_to :company
  has_many :followings
  has_many :follows, through: :followings, source: :specialist
  has_many :searches, foreign_key: :user_id, dependent: :destroy
  has_many :folders, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id
  # has_one :blacklist, foreign_key: :user_id, class_name: 'EntriesBlacklist'
  has_many :notifications, class_name: 'Notification::Users', foreign_key: :author_id

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
    AuthMailer.signup_employer(self).deliver_now
  end

  def send_company_adding_notification
    generate_auth_token!
    AuthMailer.add_company(self).deliver_now
  end

end
