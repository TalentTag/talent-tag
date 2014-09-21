@talent.controller "talent.EntryCtrl", ["$scope", "Folder", ($scope, Folder) ->

  $scope.folders = Folder.items

  toggleNewFolderInput = ->
    $scope.showNewFolderInput = !$scope.showNewFolderInput

  $scope.addFolder = (e) ->
    e.stopPropagation()
    toggleNewFolderInput()

  $scope.createFolder = (e, entry) ->
    Folder.add($(e.target).parents('li').find('input:text').eq(0).val()).then (folder) ->
      toggleNewFolderInput()
      $scope.newFolderName = ''
      folder.addEntry entry

  $scope.removeEntryFromFolder = (folder, entry) ->
    if confirm "Снять метку #{ folder.name } с записи?"
      folder.entries = _.reject(folder.entries, (e) -> entry.id is e)
      $scope.entries = _.reject($scope.entries, (e) -> entry is e) if folder is $scope.folder
      folder.removeEntry entry

  $scope.blacklist = (entry) ->
    if confirm "Убрать запись из виртуальной папки?"
      $scope.search.blacklist entry
      $scope.entries = _.reject $scope.entries, (e) -> e is entry

]
