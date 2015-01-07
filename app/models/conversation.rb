class Conversation < ActiveRecord::Base

  belongs_to :user
  belongs_to :specialist
  has_many :messages, dependent: :destroy

  default_scope -> { order last_message_at: :desc }

end
