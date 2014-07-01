@talent.controller "talent.ConversationCtrl", ["$scope", "$http", "talentData", "Message", ($scope, $http, talentData, Message) ->

  $scope.user         = talentData.user
  # $scope.conversation = talentData.conversation
  $scope.messages     = talentData.messages.map (attrs) ->
    new Message _.extend attrs, conversation_id: talentData.conversation.id

  $scope.sendMessage = ->
    message = new Message
      user_id: talentData.currentUser.id
      recipient_id: null #TODO: identify recipient user
      text: $scope.message
      created_at: 'Только что'
      conversation_id: talentData.conversation.id

    $scope.messages.push message
    $scope.message = undefined
    message.$save() #TODO: $save returns conversation_id. Need to store this to talentData.conversation.id

    # $('#conversation .modal-body').scrollTop($('#conversation .modal-body').height())

]
