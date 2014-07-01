class MessagesController < ApplicationController

  respond_to :json


  # def index
  #   respond_with Conversation.between([params[:recipient_id], current_user]).first.try :messages
  # end

  def create
    conversation = Conversation.between([params[:recipient_id], current_user]).first_or_create
    message = conversation.messages.create create_params.merge(user_id: current_user.id)

    Danthes.publish_to "/users/#{params[:recipient_id]}/messages", chat: { message: params[:message][:text], user_id: current_user.id }

    respond_with message, status: :created
  end


  private

  def create_params
    params.require(:message).permit(:text)
  end

end
