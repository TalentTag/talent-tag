class ConversationsController < ApplicationController

  respond_to :json


  def index
    gon.rabl 'app/views/conversations/index.json', locals: { conversations: current_user.conversations }, as: :conversations
  end


  def show
    conversation = Conversation.between([params[:id], current_user])

    respond_to do |format|
      format.html do
        conversations = current_user.conversations
        conversations = [Conversation.new(user_ids: [params[:id], current_user.id])] + conversations unless conversation

        gon.rabl 'app/views/conversations/index.json', locals: { conversations: conversations }, as: :conversations
        render :index
      end

      format.json do
        conversation.touch_activity! current_user
        respond_with conversation.messages
      end
    end
  end

end
