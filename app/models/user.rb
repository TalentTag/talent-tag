class User < ActiveRecord::Base

  has_secure_password

  belongs_to :company

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@[^@]+\.[a-zа-я]{2,6}\z/ }
  validates :password, length: { minimum: 6, if: :validate_password? }
  validates :phone, format: { with: /\A[+\-\(\)\d]+\z/ }, length: { in: 5..20 }, if: ->{ phone.present? }
  validates_presence_of :firstname, :midname, :lastname, :phone, on: :update

  after_create :send_signup_notification


  protected

  def validate_password?
    password.present? || password_confirmation.present?
  end

  def send_signup_notification
    AuthMailer.signup(self).deliver
  end

end
