class ConversationsController < ApplicationController
  def index
    Danthes.publish_to "/messages/new", :chat_message => "Hello, world!"    
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end
end
