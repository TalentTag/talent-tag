@talent.controller "talent.SearchesCtrl", ["$scope", "SearchesCollection", ($scope, SearchesCollection) ->
  $scope.searches = SearchesCollection.items

  $scope.loadSearch = (search) ->
    $scope.$parent.query = search.query
    $scope.$parent.fetch()

  $scope.searchesEditMode = false
  $scope.toggleSearchesEditMode = ->
    $scope.searchesEditMode = !$scope.searchesEditMode

  $scope.updateSearch = (search) ->
    search.$update()
    $scope.toggleSearchesEditMode()

  $scope.deleteSearch = (search) ->
    if confirm "Удалить виртуальную папку?"
      SearchesCollection.remove search
      $scope.searches = SearchesCollection.items
]


@talent.controller "talent.FoldersCtrl", ["$scope", "FoldersCollection", "$routeParams", ($scope, FoldersCollection, $routeParams) ->
  $scope.$parent.query = null
  $scope.$parent.noData = false
  FoldersCollection.load($routeParams.id).then (entries) -> $scope.entries = entries
]


@talent.controller "talent.FoldersListCtrl", ["$scope", "FoldersCollection", ($scope, FoldersCollection) ->
  $scope.folders = FoldersCollection.items

  $scope.foldersEditMode = false
  $scope.toggleFoldersEditMode = ->
    $scope.foldersEditMode = !$scope.foldersEditMode

  $scope.updateFolder = (folder) ->
    folder.$update()
    $scope.toggleFoldersEditMode()

  $scope.deleteFolder = (folder) ->
    if confirm "Удалить метку?"
      FoldersCollection.remove folder
      $scope.folders = FoldersCollection.items
]
