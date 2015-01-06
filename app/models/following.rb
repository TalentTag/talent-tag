class Following < ActiveRecord::Base

  self.table_name = 'specialists_users'

  belongs_to :user
  belongs_to :specialist

  after_create :notify

  def notify
    user.notifications.create event: 'following', data: { id: user.company.id, name: user.company.name }
  end

end
