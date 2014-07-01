class MessagesController < ApplicationController

  def create
    conversation = if params[:message][:conversation_id]
      Conversation.find_by!(id: params[:message][:conversation_id])
    else
      Conversation.between([params[:message][:recipient_id], current_user]).first_or_create
    end

    conversation.messages.create create_params.merge(user_id: current_user.id)

    Danthes.publish_to "/conversations/#{conversation.id}", chat_message: params[:message][:text]

    render json: conversation.id, status: :created
  end


  private

  def create_params
    params.require('message').permit(%w(text))
  end

end
