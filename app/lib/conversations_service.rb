class ConversationsService

  cattr_reader :current_user


  def self.init user
    @current_user = user
  end



  def self.conversations
    @conversations = @current_user.conversations
  end

  def self.with participant_id
    @current_user.conversations.find_by(participant_id_field => participant_id)
  end

  def self.recipient_for conversation
    participant_class.find conversation.send(participant_id_field)
  end

  def self.recipient_exists? participant_id
    participant_class.exists? participant_id
  end



  def self.add participant_id
    unless with(participant_id).present?
      @conversations = conversations + [@current_user.conversations.new(participant_id_field => participant_id)]
    end
  end

  def self.find_or_create participant_id
    with(participant_id).presence || @current_user.conversations.create(participant_id_field => participant_id)
  end

  def self.touch! conversation_id
    if conversation = @current_user.conversations.find(conversation_id)
      conversation.last_activity_will_change!
      conversation.last_activity[@current_user.type.to_s] = Time.now
      conversation.save
    end
  end



  def self.unread_messages
    conversations.flat_map do |conversation| # TODO optimize
      unread_messages_of recipient_for conversation
    end.compact
  end

  def self.unread_messages_of participant_id
    if conversation = with(participant_id)
      messages = conversation.messages.where(user_id: participant_id, source: participant_type)
      if last_checked_at = conversation.last_activity[@current_user.type.to_s]
        messages = messages.where('created_at > ?', DateTime.parse(last_checked_at))
      end
      messages
    end
  end



  private

  def self.participant_id_field
    @current_user.kind_of?(User) ? :specialist_id : :user_id
  end

  def self.participant_class
    @current_user.kind_of?(User) ? Specialist : User
  end

  def self.participant_type
    @current_user.type == :employer ? :specialist : :employer
  end

end
