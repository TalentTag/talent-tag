@talent.controller "talent.AccountCtrl", ["$scope", "$location", "Entry", "SearchesCollection", "FoldersCollection", "talentData", ($scope, $location, Entry, SearchesCollection, FoldersCollection, talentData) ->
  $scope.entries  = []
  $scope.page     = 1
  $scope.query    = ''
  $scope.keywords = _.map talentData.keywordGroups, (group) -> group.keywords[0]

  $scope.$watch 'search', ->
    if $scope.search?
      $scope.query = $scope.search.query
      $scope.page = 1
      query()


  query = (config={}) ->
    $scope.folder = null
    params = if $scope.search
      { search_id: $scope.search.id, page: $scope.page }
    else if $scope.query
      { query: $scope.query, page: $scope.page }
    Entry.query params, (data, parseHeaders) ->
      $scope.entries = if data.length
         if config.append then $scope.entries.concat(data) else data
      else []
      $scope.entriesTotal = parseInt parseHeaders()['tt-entriestotal']

  $scope.fetch = (options={}) ->
    $scope.page = 1
    $scope.search = undefined
    $location.path('/account')
    query()

  $scope.fetchMore = ->
    $scope.page = ($scope.page || 0) + 1
    query append: true

  $scope.canFetchMore = -> $scope.entries.length and $scope.entries.length < $scope.entriesTotal

  $scope.blacklist = (entry) ->
    if confirm "Убрать запись из виртуальной папки?"
      $scope.search.blacklist entry
      $scope.entries = _.reject $scope.entries, (e) -> e is entry


  $scope.saveSearch = -> SearchesCollection.add $scope.query

  $scope.clearSearch = ->
    $scope.query = ''
    $scope.entries = []
    $scope.search = $scope.entriesTotal = undefined


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
      $scope.newFolderName = ''
      folder.addEntry entry

  $scope.removeEntryFromFolder = (folder, entry) ->
    if confirm "Снять метку #{ folder.name } с записи?"
      folder.entries = _.reject(folder.entries, (e) -> entry.id is e)
      $scope.entries = _.reject($scope.entries, (e) -> entry is e) if folder is $scope.folder
      folder.removeEntry entry
]


@talent.controller "talent.EntriesCtrl", ["$scope", "$location", "$anchorScroll", ($scope, $location, $anchorScroll) ->
  if $scope.lastEntry
    $location.hash "entry#{ $scope.lastEntry.id }"
    $anchorScroll()
  $scope.lastEntry = null
]


@talent.controller "talent.DetailsCtrl", ["$scope", "$routeParams", "Entry", "$http", ($scope, $routeParams, Entry, $http) ->
  $scope.entry = _.find($scope.entries, (e) -> e.id is parseInt($routeParams.id)) || Entry.get(id: $routeParams.id, (entry) -> $scope.entry = entry)
  $scope.$parent.lastEntry = $scope.entry

  $scope.blacklist = (entry) ->
    if $scope.search and confirm("Убрать запись из виртуальной папки?")
      $scope.search.blacklist entry
      $scope.entries = _.reject $scope.entries, (e) -> e is entry

  $scope.$watch "entry.comment.text", ->
    $scope.commentUntouched = false
    
  $scope.saveComment = (comment, entry_id) ->
    if comment.id?
      $http.put "/entries/#{ entry_id }/comments/#{ comment.id }.json", text: comment.text
    else
      $http.post "/entries/#{ entry_id }/comments.json", text: comment.text
    $scope.commentUntouched = true
]
