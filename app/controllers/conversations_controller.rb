class ConversationsController < ApplicationController

  respond_to :json

  before_action :require_authentication!


  def index
    gon.rabl template: 'app/views/conversations/index.json', locals: { conversations: ConversationsService.conversations }, as: :conversations
  end


  def show
    raise ActiveRecord::RecordNotFound unless ConversationsService.recipient_exists?(params[:id])

    respond_to do |format|
      format.html do
        ConversationsService.add params[:id]
        gon.rabl template: 'app/views/conversations/index.json', locals: { conversations: ConversationsService.conversations }, as: :conversations
        render :index
      end

      format.json do
        if @conversation = ConversationsService.with(params[:id])
          ConversationsService.touch! @conversation.id
          gon.rabl template: 'app/views/conversations/show.json'
        else
          return render nothing: true
        end
      end
    end
  end


  def touch
    ConversationsService.touch! params[:id]
    render nothing: true, status: :no_content
  end

end
