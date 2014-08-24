@talent.controller "talent.B2cAccountCtrl", ["$scope", "$http", "talentData", "Entry", ($scope, $http, talentData, Entry) ->

  $scope.user = talentData.user
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
    $http.put '/account', data: normalizeParams($scope.user)

  $scope.addTag = (keyCode=null) ->
    if $scope.newTag?
      unless (keyCode? and keyCode isnt 13)
        $scope.user.tags.push $scope.newTag

  $scope.dropTag = (tag) ->
    $scope.user.tags.splice $scope.user.tags.indexOf(tag), 1

  $scope.$watch 'user.tags.length', (count) ->
    if count and talentData.profileEditable
      $scope.saveProfile()
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
