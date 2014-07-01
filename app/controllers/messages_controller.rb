class MessagesController < ApplicationController

  def create
    conversation = Conversation.find_by! id: params[:message][:conversation_id]
    conversation.messages.create create_params
    render nothing: true, status: :created
  end


  private

  def create_params
    params.require('message').permit(%w(user_id text))
  end

end
