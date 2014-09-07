@talent.controller "talent.MainCtrl", ["$scope", "$rootScope", "Notifications", ($scope, $rootScope, Notifications) ->

  $scope.Notifications = Notifications


  Danthes.subscribe "/users/#{talentData.currentUser.id}/messages", (data) ->
    $rootScope.$broadcast 'signal:new_message', data


  $rootScope.$on 'signal:new_message', (event, data) ->
    $scope.incoming = data.chat
    $scope.$apply()
    
    setTimeout ( ->
      $scope.incoming = undefined
      $scope.$apply()
    ), 6000

]
