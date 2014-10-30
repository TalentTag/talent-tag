@talent.controller "talent.FollowsCtrl", ["$scope", "talentData", "User", ($scope, talentData, User) ->

  users = talentData.users.map (attrs) -> new User attrs

  $scope.statuses = []
  $scope.tags     = []

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

  $scope.byStatus = (user) ->
    _.isEmpty($scope.statuses) or user.status in $scope.statuses

  $scope.$watch 'tags.length', (count) ->
    if count
      User.search tags: $scope.tags.join(','), (users) ->
        $scope.users = users
    else
      $scope.users = users

]
