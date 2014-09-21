@talent.controller "talent.FoldersCtrl", ["$scope", "Folder", "$routeParams", ($scope, Folder, $routeParams) ->

  $scope.reset()

  Folder.load $routeParams.id, (entries) ->
    $scope.entries = entries

]
