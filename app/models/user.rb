class User < ActiveRecord::Base

  has_secure_password

  belongs_to :company
  has_many :identities
  has_many :entries
  has_many :searches
  has_many :folders
  has_many :comments
  has_one :blacklist, class_name: 'EntriesBlacklist'

  has_many :conversations_users
  has_and_belongs_to_many :conversations

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@[^@]+\.[a-zа-я]{2,6}\z/ }
  validates :password, length: { minimum: 6, if: :validate_password?, too_short: "не менее 6 символов" }
  validates :phone, format: { with: /\A[+\-\(\)\d]+\z/ }, length: { in: 5..20 }, if: ->{ phone.present? }
  validates_presence_of :firstname, :midname, :lastname, :phone, on: :update, if: ->{ role.present? }

  after_create :send_signup_notification
  after_update :send_update_confirmation

  %w(auth forgot).each do |name|
    define_method("generate_#{name}_token".to_sym) do
      public_send("#{name}_token=", Digest::MD5.hexdigest(Time.now.to_s + email)) if email.present?
    end

    define_method("generate_#{name}_token!".to_sym) do
      public_send("generate_#{name}_token")
      save validate: false
    end
  end

  def generate_cookie &block
    instance_exec { block.call({ value: "#{id}|#{auth_token}", expires: 1.month.from_now }) }
  end


  ROLES = %w[owner employee admin]
  ROLES.each do |r|
    define_method("#{r}?") { r == role }
  end

  def name
    firstname && lastname ? "#{ firstname } #{ lastname }" : email
  end

  def update_password! values
    self.password = values['password']
    self.password_confirmation = values['password_confirmation']
    self.forgot_token = nil
    valid?
    save validate: false if errors[:password].empty? && errors[:password_confirmation].empty?
  end

  def update_personal_data! data
    self.firstname  = data[:firstname]
    self.lastname   = data[:lastname]
    profile_will_change!
    profile.reverse_merge! data[:profile]
    save
  end

  def post_comment entry, text
    comments.create entry_id: entry.id, text: text
  end

  def send_company_adding_notification
    generate_auth_token!
    AuthMailer.add_company(self).deliver
  end

  def avatar
    profile['image'] || '/no_avatar.jpg'
  end


  protected

  def validate_password?
    password.present? || password_confirmation.present?
  end

  def send_signup_notification
    AuthMailer.send("signup_#{ role || "default" }", self).deliver unless role.nil?
  end

  def send_update_confirmation
    AuthMailer.forgot(self).deliver if forgot_token_changed? && forgot_token
    AuthMailer.credentials(self).deliver if email_changed? || password_digest_changed?
  end

end
