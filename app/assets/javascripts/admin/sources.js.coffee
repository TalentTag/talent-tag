@talent.controller "talent.SourceCtrl", ["$scope", "SourceCollection", ($scope, SourceCollection) ->
  $scope.sources = SourceCollection.filter()
  $scope.group = 'all'
  $scope.$watch 'group', ->
    $scope.sources = SourceCollection.filter $scope.group

  $scope.displayed = (group) -> 'active' if group is $scope.group 
  $scope.switchGroup = (group) -> $scope.group = group
]
