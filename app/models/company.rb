class Company < ActiveRecord::Base

  has_one :owner, class_name: "User"
  has_many :users
  has_many :invites
  has_one :proposal

  accepts_nested_attributes_for :owner

  validates :name, presence: true
  validates :phone, format: { with: /\A[+\-\(\)\d]+\z/ }, length: { in: 5..20 }, if: ->{ phone.present? }
  validates_presence_of :owner, :website, :phone, :address, :details, on: :update

  after_create :set_owner


  def owner
    @owner ||= User.find(owner_id) rescue nil
  end

  def employee
    users.where role: :employee
  end

  def confirmed?
    !confirmed_at.nil? # @TODO is it still necessary?
  end

  def detailed?
    %w(website phone address details).map { |f| send(f).present? }.all?
  end

  def premium?
    premium_since && premium_until > Time.now
  end

  def go_premium! rate
    starting_point = [premium_until, Time.now].max rescue Time.now
    update premium_since: Time.now, premium_until: starting_point + rate[:duration]
  end

  def blocked?
    !premium? && (created_at < 3.hours.ago || premium_since)
  end


  protected

  def set_owner
    update_attribute :owner_id, users.first.id
  end

end
