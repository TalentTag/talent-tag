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
    users.reject { |u| u == owner }
  end

  def confirm!
    update confirmed_at: Time.now
  end

  def confirmed?
    !confirmed_at.nil?
  end

  def detailed?
    %w(website phone address details).map { |f| send(f).present? }.all?
  end


  protected

  def set_owner
    update_attribute :owner_id, users.first.id
  end

end
