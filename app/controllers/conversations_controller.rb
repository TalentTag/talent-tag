class ConversationsController < ApplicationController

  def index
    @conversations = Conversation.with current_user
  end

  def with
    @conversation = Conversation.between([params[:recipient_id], current_user]).first
    @messages = @conversation.try(:messages) || []
  end

end
