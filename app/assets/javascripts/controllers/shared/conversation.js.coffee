@talent.controller "talent.ConversationsCtrl", ["$scope", "talentData", "$rootScope", "Message", ($scope, talentData, $rootScope, Message) ->

  $scope.currentUser    = talentData.currentUser
  $scope.conversations  = talentData.conversations

  recieveMessage = (data) ->
    conversation = _.findWhere $scope.conversations, id: data.conversation_id
    if conversation?
      conversation.last_message.text        = data.message
      conversation.last_message.created_at  = data.date
      conversation.unread_messages          = ((conversation.unread_messages || 0) + 1) unless conversation.active
      $scope.$apply()

  $rootScope.$on 'signal:new_message', (event, data) ->
    recieveMessage data.chat

]



@talent.controller "talent.MessagesCtrl", ["$scope", "$http", "$routeParams", "$rootScope", "Message", ($scope, $http, $routeParams, $rootScope, Message) ->

  $scope.currentConversation = _.find $scope.conversations, (conversation) ->
    c.active = false for c in $scope.conversations
    conversation.active = true
    conversation.recipient.id is parseInt $routeParams.recipient_id

  $scope.messages = []
  $http.get("/account/conversations/#{ $scope.currentConversation.recipient.id }").success (conversation) ->
    $scope.messages = (new Message(attrs) for attrs in conversation.messages)
    $scope.recipient = conversation.recipient
    $scope.currentConversation.unread_messages = 0

  recieveMessage = (data) ->
    newMessage = new Message
      user_id:          data.user_id
      recipient_id:     $scope.currentUser.id
      text:             data.message
      created_at:       data.date
      conversation_id:  data.conversation_id
      user:             $scope.recipient
    $scope.messages.push newMessage

    conversation = newMessage.conversation()
    if $scope.currentConversation and conversation is $scope.currentConversation
      $http.put "/account/conversations/#{ conversation.id }/touch"

  sendMessage = (conversation) ->
    message = new Message
      user_id:      $scope.currentUser.id
      recipient_id: $scope.recipient.id
      text:         $scope.message
      user:         $scope.currentUser
    $scope.messages.push message
    $scope.message = undefined
    $http.post "/account/messages", message

  $scope.sendMessage = sendMessage

  $rootScope.$on 'signal:new_message', (event, data) ->
    recieveMessage data.chat

  $scope.$watch 'messages.length', ->
    _.defer -> $('html, body').animate { scrollTop: $(document).height() }, 'slow'

]
