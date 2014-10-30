@talent.controller "talent.SourceCtrl", ["$scope", "Source", ($scope, Source) ->

  $scope.sources = Source.filter()
  $scope.$watch 'group', ->
    $scope.sources = Source.filter $scope.group

]
