@talent.controller "talent.ConversationCtrl", ["$scope", "$http", "talentData", "Message", ($scope, $http, talentData, Message) ->

  $scope.user         = talentData.user
  $scope.messages     = talentData.messages?.map((attrs) -> new Message attrs) or []
  # Message.query recipient_id: talentData.user.id, (data) ->
  #   $scope.messages = data.map (attrs) -> new Message attrs


  $scope.sendMessage = ->
    message = new Message
      # user_id: talentData.currentUser.id
      recipient_id: talentData.user.id
      text: $scope.message
      created_at: 'Только что'

    $scope.messages.push message
    $scope.message = undefined
    message.$save()

    # $('#conversation .modal-body').scrollTop($('#conversation .modal-body').height())

]
