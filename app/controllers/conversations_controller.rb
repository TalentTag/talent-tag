class ConversationsController < ApplicationController

  respond_to :json

  before_action :require_authentication!


  def index
    gon.rabl template: 'app/views/conversations/index.json', locals: { conversations: current_user.conversations }, as: :conversations
  end


  def show
    raise ActiveRecord::RecordNotFound unless User.exists?(params[:id])
    conversation = Conversation.between([params[:id], current_user])

    respond_to do |format|
      format.html do
        conversations = current_user.conversations
        conversations = [Conversation.new(user_ids: [params[:id], current_user.id])] + conversations unless conversation

        gon.rabl template: 'app/views/conversations/index.json', locals: { conversations: conversations }, as: :conversations
        render :index
      end

      format.json do
        if conversation
          conversation.touch_activity! current_user
          respond_with conversation.messages.order(created_at: :desc).limit(20).reverse
        else
          respond_with []
        end
      end
    end
  end


  def touch
    Conversation.find_by!(id: params[:id]).touch_activity! current_user
    render nothing: true, status: :no_content
  end

end
