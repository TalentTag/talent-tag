@talent.controller "talent.AccountCtrl", ["$scope", "Entry", "SearchesCollection", "FoldersCollection", "talentData", ($scope, Entry, SearchesCollection, FoldersCollection, talentData) ->
  $scope.entries  = []
  $scope.page     = 1
  $scope.query    = ''
  $scope.keywords = _.map talentData.keywordGroups, (group) -> group.keywords[0]

  query = (config={}) ->
    if $scope.query
      $scope.folder = null
      Entry.query { query: $scope.query, page: $scope.page }, (data, parseHeaders) ->
        if data.length
          $scope.entries = if config.append then $scope.entries.concat(data) else data
          $scope.totalPages = parseHeaders()['tt-pagecount']
        else
          $scope.noData = true
          $scope.entries = []

  $scope.fetch = ->
    $scope.noData = null
    $scope.page = 1
    query()

  $scope.fetchMore = ->
    $scope.page = ($scope.page || 0) + 1
    query append: true

  $scope.canFetchMore = -> $scope.page < $scope.totalPages and $scope.entries.length

  $scope.blacklist = (entry) ->
    if confirm "Убрать запись из выдачи?"
      entry.blacklist()
      $scope.entries = _.reject $scope.entries, (e) -> e is entry

  $scope.saveSearch = -> SearchesCollection.add $scope.query


  $scope.folders = FoldersCollection.items

  $scope.showNewFolderInput = false
  toggleNewFolderInput = ->
    $scope.showNewFolderInput = !$scope.showNewFolderInput

  $scope.addFolder = (e) ->
    e.stopPropagation()
    toggleNewFolderInput()

  $scope.createFolder = (e, entry) ->
    FoldersCollection.add($(e.target).parents('li').find('input:text').eq(0).val()).then (folder) ->
      toggleNewFolderInput()
      folder.addEntry entry

  $scope.removeEntryFromFolder = (folder, entry) ->
    if confirm "Снять метку #{ folder.name } с записи?"
      $scope.entries = _.reject $scope.entries, (e) -> entry is e
      folder.removeEntry entry
]
