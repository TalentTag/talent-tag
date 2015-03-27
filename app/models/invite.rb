class Invite < ActiveRecord::Base

  belongs_to :company

  validates_presence_of :company
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@[^@]+\.[a-zа-я]{2,6}\z/ }

  before_create :generate_code
  after_create :send_notification


  protected

  def generate_code
    self.code = SecureRandom.hex(10)
  end

  def send_notification
    AuthMailer.invite(self).deliver
  end

end
