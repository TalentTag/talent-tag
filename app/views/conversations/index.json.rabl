collection @conversations

attribute :id

node :recipient do |conversation|
  partial "/users/show", object: conversation.recipient(current_user)
end

attribute :last_message_at

node :unread_messages do |conversation|
  conversation.unread_messages(current_user)
end

node :messages_count do |conversation|
  conversation.messages.count
end

attribute :last_message
