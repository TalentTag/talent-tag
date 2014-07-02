class MessagesController < ApplicationController

  respond_to :json


  def create
    conversation = Conversation.between([params[:recipient_id], current_user]).first_or_create
    message = conversation.messages.create user_id: current_user.id, text: params[:text]

    Danthes.publish_to "/users/#{params[:recipient_id]}/messages", chat: {conversation_id: conversation.id, message: params[:message][:text], user_id: current_user.id, date: message.created_at }

    respond_with message, status: :created
  end

end
