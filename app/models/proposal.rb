class Proposal < ActiveRecord::Base

  belongs_to :company

  after_save :confirm_account#, :send_notification

  scope :awaiting, ->{ where(status: 'awaiting') }
  default_scope { order(created_at: :desc) }

  STATUSES = %w(awaiting accepted rejected)
  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
  end


  protected

  def confirm_account
    company.confirm!# if status_changed? && status.to_s == 'accepted'
  end

  # def send_notification
  #   ProposalMailer.send(status, self).deliver if status_changed?
  # end

end
