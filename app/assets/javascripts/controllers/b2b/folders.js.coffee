@talent.controller "talent.FoldersCtrl", ["$scope", "Folder", "$routeParams", ($scope, Folder, $routeParams) ->

  $scope.reset()

  $scope.entriesTotalInFolder = 0
  Folder.load $routeParams.id, (entries) ->
    $scope.entriesTotalInFolder = entries.length
    $scope.entries = entries

]
