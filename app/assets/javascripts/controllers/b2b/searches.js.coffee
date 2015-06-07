@talent.controller "talent.SearchListCtrl", ["$scope", "Search", "State", ($scope, Search, State) ->

  $scope.Search = Search

  $scope.loadSearch = (search) ->
    State.init query: search.query, location: { name: search.filters?.location }, silent: true
    Search.current = search

  $scope.searchesEditMode = false
  $scope.toggleSearchesEditMode = ->
    $scope.searchesEditMode = !$scope.searchesEditMode

  $scope.updateSearch = (search) ->
    search.$update()
    $scope.toggleSearchesEditMode()

  $scope.deleteSearch = (search) ->
    search.remove() if confirm "Удалить виртуальную папку?"
]


@talent.controller "talent.FolderListCtrl", ["$scope", "Folder", ($scope, Folder) ->

  $scope.Folder = Folder

  $scope.toggleFoldersEditMode = ->
    $scope.foldersEditMode = !$scope.foldersEditMode

  $scope.updateFolder = (folder) ->
    folder.$update()
    $scope.toggleFoldersEditMode()

  $scope.deleteFolder = (folder) ->
    if folder? and confirm "Удалить метку?"
      Folder.items = _.reject Folder.items, (f) -> folder is f
      folder.$remove()
      $scope.$parent.folders = Folder.items
]
