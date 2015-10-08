class Company < ActiveRecord::Base

  EMPLOYEE_LIMIT = 5


  has_one :owner, class_name: "User"
  has_many :users
  has_many :invites
  has_one :proposal
  has_many :payments

  accepts_nested_attributes_for :owner

  validates :name, presence: true, length: { maximum: 100, too_long: "не более 100 символов" }
  validates :phone, format: { with: /\A[+\-\(\)\d]+\z/ }, length: { in: 5..20 }, if: ->{ phone.present? }
  validates_presence_of :owner, :website, :phone, :address, :details, on: :update
  # TODO make unique in scope of user

  after_create :set_owner


  def owner
    @owner ||= User.find(owner_id) unless owner_id.nil?
  end

  def employee
    users.where role: :employee
  end

  def detailed?
    %w(website phone address details).map { |f| send(f).present? }.all?
  end

  def can_have_more_employee?
    employee.count + invites.count < EMPLOYEE_LIMIT
  end

  def premium?
    (premium_since && premium_until > Time.now) || owner.admin?
  end

  def go_premium! plan
    starting_point = [premium_until, Time.now].max rescue Time.now
    update premium_since: Time.now, premium_until: starting_point + plan.duration
  end

  def blocked?
    !premium? && created_at < 3.hours.ago
  end


  protected

  def set_owner
    update_attribute :owner_id, users.first.id unless owner
  end

end
