class ConversationsController < ApplicationController

  respond_to :json

  before_action :require_authentication!


  def index
    gon.rabl 'app/views/conversations/index.json', locals: { conversations: current_user.conversations }, as: :conversations
  end


  def show
    raise ActiveRecord::RecordNotFound unless User.exists?(params[:id])
    conversation = Conversation.between([params[:id], current_user])

    respond_to do |format|
      format.html do
        conversations = current_user.conversations
        conversations = [Conversation.new(user_ids: [params[:id], current_user.id])] + conversations unless conversation

        gon.rabl 'app/views/conversations/index.json', locals: { conversations: conversations }, as: :conversations
        # TODO pick current conversation in JS
        render :index
      end

      format.json do
        if conversation
          conversation.touch_activity! current_user
          respond_with conversation.messages
        else
          respond_with []
        end
      end
    end
  end

end
