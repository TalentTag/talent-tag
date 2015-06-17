@talent.controller "talent.B2cAccountCtrl", ["$scope", "$http", "talentData", "Entry", ($scope, $http, talentData, Entry) ->

  $scope.user = talentData.currentUser
  $scope.user.tags ?= []

  $scope.statuses = talentData.statuses
  $scope.userStatus = talentData.currentUser.status
  $scope.$watch 'userStatus', (status, oldStatus) ->
    $http.put '/account/status', { status } if status isnt oldStatus


  normalizeParams = (params) ->
    for key, value of params
      delete params[key] if !value or value==''
    params


  $scope.saveProfile = ->
    $http.put '/account', data: normalizeParams($scope.user.profile)


  $scope.tags = 
    add: (keyCode=null) ->
      if $scope.newTag and (if keyCode? then keyCode is 13 else true)
        $scope.user.tags.push $scope.newTag
        $scope.newTag = ""
    drop: (tag) ->
      $scope.user.tags.splice $scope.user.tags.indexOf(tag), 1

  $scope.$watch 'user.tags.length', (count) ->
    if count
      $http.put "/users/#{ $scope.user.id }.json", user: { tags: $scope.user.tags }
      $scope.newTag = undefined


  $scope.follow = (follow=true) ->
    $http.post "/users/#{ talentData.user.id }/follow", { follow }
    $scope.follows = follow


  $scope.toggleEntryForm = ->
    $scope.entryFormDisplayed = !$scope.entryFormDisplayed

  $scope.postEntry = ->
    new Entry(body: $scope.entryBody).$save ->
      window.location.reload()

]
