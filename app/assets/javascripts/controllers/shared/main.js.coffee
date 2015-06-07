@talent.controller "talent.MainCtrl", ["$scope", "talentData", "$rootScope", "State", "Notifications", ($scope, talentData, $rootScope, State, Notifications) ->

  $scope.Notifications = Notifications


  if talentData?.currentUser?
    Danthes.subscribe "/#{talentData.currentUser.type}/#{talentData.currentUser.id}/messages", (data) ->
      $rootScope.$broadcast 'signal:new_message', data


  $rootScope.$on 'signal:new_message', (event, data) ->
    $scope.incoming = data.chat
    $scope.$apply()
    
    setTimeout ( ->
      $scope.incoming = undefined
      $scope.$apply()
    ), 6000


  State.onChange ->
    window.history.pushState null, null, '/'

]
