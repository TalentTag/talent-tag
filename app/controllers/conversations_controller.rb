class ConversationsController < ApplicationController

  def index
    @conversations = current_user.conversations
  end

  def with
    @user = User.find_by! id: params[:recipient_id]
    @conversation = Conversation.between([params[:recipient_id], current_user])

    @conversation.try(:touch_activity, current_user)

    gon.rabl 'app/views/users/show.json', locals: { user: @user }, as: :user
    gon.messages = @conversation.messages rescue []
  end

end
