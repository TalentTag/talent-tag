class MessagesController < ApplicationController

  respond_to :json


  def create
    conversation = ConversationsService.find_or_create(params[:recipient_id])
    message = conversation.messages.create user_id: current_user.id, source: current_user.type, text: params[:text]

    Danthes.publish_to "/#{ConversationsService.recipient_for(conversation).type}/#{params[:recipient_id]}/messages", chat: {
      conversation_id: conversation.id,
      message: message.text,
      user_id: current_user.id,
      date: message.created_at
    }
    respond_with message, status: :created
  end

end
