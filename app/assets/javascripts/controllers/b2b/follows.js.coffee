@talent.controller "talent.FollowsCtrl", ["$scope", "talentData", ($scope, talentData) ->

  $scope.users = talentData.users

  $scope.statuses = []
  $scope.tags     = []

  $scope.passesFilters = (user) ->
    return false if $scope.statuses.length and user.status not in $scope.statuses
    return false if $scope.tags.length and _.intersection($scope.tags, user.tags).length is 0
    true

  $scope.toggleStatus = (status) ->
    if status in $scope.statuses
      $scope.statuses = _.reject $scope.statuses, (s) -> s is status
    else
      $scope.statuses.push status

  $scope.toggleTag = (tag) ->
    if tag in $scope.tags
      $scope.tags = _.reject $scope.tags, (t) -> t is tag
    else
      $scope.tags.push tag

  $scope.addTag = (keyCode=null) ->
    if $scope.newTag
      unless (keyCode? and keyCode isnt 13)
        $scope.tags.push $scope.newTag unless $scope.newTag in $scope.tags
        $scope.newTag = ""


]
