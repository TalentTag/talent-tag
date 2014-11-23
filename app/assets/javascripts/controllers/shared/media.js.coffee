@talent.controller "talent.MediaCtrl", ["$scope", ($scope) ->

  $scope.currentTag = null
  $scope.tagIn = (tags) -> $scope.currentTag in tags
  $scope.pickTag = (tag) -> $scope.currentTag = tag

]
