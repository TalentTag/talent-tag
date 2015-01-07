collection @conversations

attribute :id

node :recipient do |conversation|
  partial "/users/show", object: ConversationsService.recipient_for(conversation)
end

node :unread_messages do |conversation|
  ConversationsService.unread_messages.count
end

node :messages_count do |conversation|
  conversation.messages.count
end

node :last_message do |conversation|
  conversation.messages.order(id: :desc).limit(1).first
end

attributes :last_message_at
