@talent.controller "talent.ConversationCtrl", ["$scope", "$http", "talentData", "$rootScope", "Message", "Danthes", ($scope, $http, talentData, $rootScope, Message, Danthes) ->

  $scope.user         = talentData.user
  $scope.messages     = talentData.messages?.map((attrs) -> new Message attrs) or []
  # Message.query recipient_id: talentData.user.id, (data) ->
  #   $scope.messages = data.map (attrs) -> new Message attrs

  add_message = (data) ->
    msg = new Message
      recipient_id: talentData.user.id
      text:         data.message
      created_at:   data.date
    $scope.messages.push msg
    $scope.$apply()


  $scope.sendMessage = ->
    add_message message: $scope.message, created_at: 'Только что'
    $scope.message = undefined
    message.$save()

    # $('#conversation .modal-body').scrollTop($('#conversation .modal-body').height())



  Danthes.subscribe "/users/#{talentData.currentUser.id}/messages", (data) ->
    $rootScope.$broadcast 'signal:new_message', data
    add_message data.chat

]
