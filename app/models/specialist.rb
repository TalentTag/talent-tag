class Specialist < ActiveRecord::Base

  include UserConcern


  has_many :identities, foreign_key: :user_id, dependent: :destroy
  has_many :entries, foreign_key: :user_id
  has_many :portfolio, foreign_key: :user_id

  after_create :send_signup_notification

  STATUSES = %w(ignore active passive)


  def type() :specialist end


  def send_signup_notification
    AuthMailer.signup_default(self).deliver unless role.nil?
  end

  def notify
    Notification.create author_id: id, event: "status_change", data: status if status_changed?
  end

end
