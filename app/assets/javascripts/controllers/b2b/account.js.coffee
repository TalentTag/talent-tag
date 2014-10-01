@talent.controller "talent.AccountCtrl", ["$scope", "$location", "Entry", "Search", "Folder", "talentData", ($scope, $location, Entry, Search, Folder, talentData) ->

  $scope.Search   = Search
  $scope.Folder   = Folder

  $scope.company  = talentData.company

  $scope.entries  = []
  $scope.page     = 1
  $scope.query    = ''
  $scope.keywords = _.map talentData.keywordGroups, (group) -> group.keywords[0]


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

  $scope.keyPressFetch = (keyCode) ->
    $scope.fetch() if keyCode is 13


  $scope.fetchMore = ->
    if $scope.canFetchMore()
      $scope.page = ($scope.page || 0) + 1
      query append: true

  $scope.canFetchMore = ->
    $scope.entries.length and $scope.entries.length < $scope.entriesTotal

  $scope.saveSearch = -> Search.add $scope.query

  $scope.reset = ->
    $scope.query = ''
    $scope.entries = []
    $scope.search = $scope.entriesTotal = undefined

]
