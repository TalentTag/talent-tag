@talent.controller "talent.ConversationsCtrl", ["$scope", "talentData", ($scope, talentData) ->

  $scope.currentUser    = talentData.currentUser
  $scope.conversations  = talentData.conversations

]



@talent.controller "talent.MessagesCtrl", ["$scope", "$http", "$rootScope", "$routeParams", "Message", ($scope, $http, $rootScope, $routeParams, Message) ->

  $scope.currentConversation = _.find $scope.conversations, (conversation) ->
    conversation.recipient.id is parseInt $routeParams.recipient_id

  $scope.messages = []
  $http.get("/account/conversations/#{ $scope.currentConversation.recipient.id }").success (messages) ->
    $scope.messages = (new Message(attrs) for attrs in messages)
    $scope.currentConversation.unread_messages = 0


  recieveMessage = (data) ->
    newMessage = new Message
      user_id:          data.user_id
      recipient_id:     $scope.currentUser.id
      text:             data.message
      created_at:       data.date
      conversation_id:  $scope.currentConversation.id
    $scope.messages.push newMessage

    conversation = newMessage.conversation()
    if $scope.currentConversation and conversation is $scope.currentConversation
      $http.put "/account/conversations/#{ conversation.id }/touch"
    else
      conversation.unread_messages = (newMessage.conversation().unread_messages || 0) + 1
    $scope.$apply()


  sendMessage = (conversation) ->
    message = new Message
      user_id:      $scope.currentUser.id
      recipient_id: conversation.recipient.id
      text:         $scope.message
      created_at:   'Только что'
    $scope.messages.push message
    $scope.message = undefined
    message.$save()

  $scope.sendMessage = sendMessage


  $rootScope.$on 'signal:new_message', (event, data) ->
    recieveMessage data.chat

  $scope.$watch 'messages.length', ->
    _.defer -> $('html, body').animate { scrollTop: $(document).height() }, 'slow'

]
