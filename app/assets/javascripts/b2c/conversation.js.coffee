@talent.controller "talent.ConversationCtrl", ["$scope", "$http", "talentData", "$rootScope", "Message", "Danthes", ($scope, $http, talentData, $rootScope, Message, Danthes) ->

  $scope.user         = talentData.user
  $scope.messages     = talentData.messages?.map((attrs) -> new Message attrs) or []
  # Message.query recipient_id: talentData.user.id, (data) ->
  #   $scope.messages = data.map (attrs) -> new Message attrs

  recieveMessage = (data) ->
    $scope.messages.push new Message
      user_id:      data.user_id
      recipient_id: talentData.currentUser.id
      text:         data.message
      created_at:   data.date
    $scope.$apply()

  sendMessage = ->
    message = new Message
      user_id:      talentData.currentUser.id
      recipient_id: talentData.user.id
      text:         $scope.message
      created_at:   'Только что'
    $scope.messages.push message
    $scope.message = undefined
    message.$save()

  $scope.sendMessage = sendMessage


  $scope.$watch 'messages.length', ->
    _.defer -> $('html, body').animate { scrollTop: $(document).height() }, 'slow'


  Danthes.subscribe "/users/#{talentData.currentUser.id}/messages", (data) ->
    $rootScope.$broadcast 'signal:new_message', data
    recieveMessage data.chat

]
