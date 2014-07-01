class Conversation < ActiveRecord::Base

  has_many :messages

  # scope :with, ->(user) { where "#{ user.id } = ANY (participants)" }
  scope :between, ->(users) { where(participants: users.map{|u| u.try(:id) || u.to_i }.sort) }


  def addressee user
    User.find participants.keep_if { |id| id!=user.id }.first
  end

end
