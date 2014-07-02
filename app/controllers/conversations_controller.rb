class ConversationsController < ApplicationController

  def index
    @conversations = Conversation.with current_user
  end

  def with
    gon.user = User.find_by! id: params[:recipient_id]
    @conversation = Conversation.between([params[:recipient_id], current_user]).first
    gon.messages = @conversation.try(:messages) || []
  end

end
