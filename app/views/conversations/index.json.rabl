collection @conversations

attribute :id

node :recipient do |conversation|
  partial "/users/show", object: conversation.recipient(current_user)
end

node :unread_messages do |conversation|
  conversation.unread_messages_count(current_user)
end

node :messages_count do |conversation|
  conversation.messages.count
end

attributes :last_message, :last_message_at
