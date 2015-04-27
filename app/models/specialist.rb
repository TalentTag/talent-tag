class Specialist < ActiveRecord::Base

  include UserConcern
  include PrepareQuery

  ENTRIES_PER_PAGE = 10
  paginates_per ENTRIES_PER_PAGE


  has_many :followings
  has_and_belongs_to_many :followed_by, class_name: 'User'
  has_many :identities, foreign_key: :user_id, dependent: :destroy
  has_many :entries, foreign_key: :user_id
  has_many :portfolio, foreign_key: :user_id
  has_many :notifications, class_name: 'Notification::Specialists', foreign_key: :author_id

  after_create :send_signup_notification
  after_update :notify

  STATUSES = %w(ignore active passive)


  def type() :specialist end


  def self.filter params={}
    page = params[:page] || 1
    users = Specialist.search search_query(params[:query]), order: 'created_at DESC'
    users.page(page).per(ENTRIES_PER_PAGE)
  end


  def send_signup_notification
    AuthMailer.signup_specialist(self).deliver
  end

  def notify
    notifications.create(event: "status_change", data: { from: status_was, to: status }) if status_changed?
  end

  def ban! state=true
    update can_login: !state
  end

end
