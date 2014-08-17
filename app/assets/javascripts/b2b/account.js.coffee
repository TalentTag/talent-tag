@talent.controller "talent.AccountCtrl", ["$scope", "$location", "Entry", "SearchesCollection", "FoldersCollection", "talentData", ($scope, $location, Entry, SearchesCollection, FoldersCollection, talentData) ->
  $scope.company  = talentData.company

  $scope.entries  = []
  $scope.page     = 1
  $scope.query    = ''
  $scope.keywords = _.map talentData.keywordGroups, (group) -> group.keywords[0]

  timer = (new Date($scope.company.created_at).getTime() + 3600*3*1000 - new Date().getTime()) / 1000
  if timer > 0
    tickTimer = ->
      window.location.reload() if timer <= 0
      timer--
      $scope.$apply ->
        $scope.timeLeft = "#{ Math.floor timer/3600 }:#{ ("0" + Math.floor timer%3600/60).slice(-2) }:#{ ("0" + Math.floor timer%60).slice(-2) }"
    setInterval tickTimer, 1000


  querystring = undefined

  $scope.$watch 'search', (search) ->
    if search?
      $scope.query = querystring = search.query
      $scope.page = 1
      query()

  query = (config={}) ->
    $scope.fetchinInProgress = true

    $scope.folder = null
    params = if $scope.search
      { query: querystring, search_id: $scope.search.id, page: $scope.page }
    else if querystring
      { query: querystring, page: $scope.page }
    params['club_members_only'] = true if $scope.clubMembersOnly
    Entry.query params, (data, parseHeaders) ->
      $scope.entries = if data.length
        if config.append then $scope.entries.concat(data) else data
      else []
      $scope.entriesTotal = parseInt parseHeaders()['tt-entriestotal']
      unless $scope.entriesTotal
        querystring = undefined
        $scope.searchInResults = false

      $scope.fetchinInProgress = false

  $scope.fetch = (options={}) ->
    if $scope.query
      $scope.page = 1
      $scope.search = undefined unless $scope.searchInResults
      $location.path('/')

      querystring = if querystring? and $scope.searchInResults 
        "(#{ querystring }) && (#{ $scope.query })"
      else
        $scope.query
      query()

  $scope.fetchMore = ->
    if $scope.canFetchMore()
      $scope.page = ($scope.page || 0) + 1
      query append: true

  $scope.canFetchMore = ->
    $scope.entries.length and $scope.entries.length < $scope.entriesTotal

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
