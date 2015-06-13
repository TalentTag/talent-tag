@talent.controller "talent.AccountCtrl", ["$scope", "talentData", "$q", "$timeout", "State", "Entry", "User", "Presets", "Search", ($scope, talentData, $q, $timeout, State, Entry, User, Presets, Search) ->

  $scope.state   = State
  $scope.presets = Presets.all
  $scope.entries = []
  $scope.page    = 1 # TODO relocate to State

  State.location = talentData.locations[0]

  fetch = (options={}) ->
    $scope.page = 1 unless options.append

    params =
      query:      State.query
      location:   State.location?.name
      page:       $scope.page
      search_id:  Search.current?.id

    fetchEntries = ->
      fetching = $q.defer()
      Entry.query params, (data, parseHeaders) ->
        $scope.entries = if options.append then $scope.entries.concat(data) else data
        $scope.entriesTotal = +parseHeaders()['tt-entriestotal']
        fetching.resolve()
      fetching.promise

    fetchSpecialists = ->
      fetching = $q.defer()
      User.query params, (data, parseHeaders) ->
        $scope.specialists = if options.append then $scope.specialists.concat(data) else data
        $scope.specialistsTotal = +parseHeaders()['tt-specstotal']
        fetching.resolve()
      fetching.promise

    $scope.loadInProgress = true
    $q.all([fetchEntries(), fetchSpecialists()]).then ->
      $scope.loadInProgress = false

  initFetching = ->
    if State.query
      $timeout (-> $scope.preloaderVisible = true if $scope.loadInProgress), 250
      fetch().then -> $scope.preloaderVisible = false
  $scope.$watch 'state.query', initFetching
  $scope.$watch 'state.location', initFetching

  $scope.pickKeyword = (query) ->
    State.init {query}

  $scope.fetchMore = ->
    if $scope.canFetchMore()
      $scope.page++
      fetch append: true

  $scope.canFetchMore = ->
    $scope.entries.length and $scope.entries.length < $scope.entriesTotal

]
