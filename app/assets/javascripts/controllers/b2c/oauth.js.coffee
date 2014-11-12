@talent.controller 'talent.OauthCtrl', ["$scope", "talentData", "$http", ($scope, talentData, $http) ->

  $scope.identity =
    provider: talentData.identity.provider
    uid: talentData.identity.uid
    user_attributes: talentData.info
    raw_data: talentData.identity.raw_data

  $scope.saveIdentity = ->
    $scope.error = undefined
    $http.post('/identities', identity: $scope.identity).success( ->
      window.location = '/'
    ).error( (response) ->
      $scope.error = response.errors['user.email']
    )

]
