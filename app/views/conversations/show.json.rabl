object @conversation

node :recipient do |conversation|
  partial "/users/show", object: ConversationsService.recipient_for(conversation)
end

node :messages do |conversation|
  partial "/messages/index", object: conversation.messages
end
