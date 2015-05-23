@talent.controller "talent.AccountCtrl", ["$scope", "$location", "Entry", "User", "Search", "Folder", "talentData", "State", ($scope, $location, Entry, User, Search, Folder, talentData, State) ->

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
      $scope.query = querystring = Search.current.query
      $scope.location = search.filters.location
      $scope.page = 1
      query()


  query = (config={}) ->
    $scope.fetchinInProgress = true

    $scope.folder = null
    params = if $scope.search
      { query: querystring, search_id: $scope.search.id, page: $scope.page }
    else if querystring
      { query: querystring, page: $scope.page, location: State.location() }
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

    User.query { query: querystring, page: $scope.page }, (data, parseHeaders) ->
      $scope.specialists = data
      $scope.specialistsTotal = parseInt parseHeaders()['tt-specstotal']


  $scope.fetch = (searchquery=null) ->
    if searchquery
      $scope.query = searchquery
    else searchquery ?= $scope.query

    if searchquery
      $scope.page = 1
      unless $scope.searchInResults
        $scope.search   = undefined
        Search.current  = undefined
      $location.path('/')

      querystring = if querystring? and $scope.searchInResults 
        "(#{ querystring }) && (#{ searchquery })"
      else
        searchquery
      query()

  $scope.keyPressFetch = (keyCode) ->
    $scope.fetch() if keyCode is 13


  $scope.fetchMore = ->
    if $scope.canFetchMore()
      $scope.page = ($scope.page || 0) + 1
      query append: true

  $scope.canFetchMore = ->
    $scope.entries.length and $scope.entries.length < $scope.entriesTotal

  $scope.saveSearch = -> Search.add $scope.query, location: State.location()

  reset = ->
    $scope.entries = []
    $scope.search = $scope.entriesTotal = undefined
  $scope.reset = -> $scope.query = ''; reset()
  $scope.$watch 'search', -> reset()

]
