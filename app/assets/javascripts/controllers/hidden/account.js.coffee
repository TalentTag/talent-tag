@talent.controller "talent.HiddenAccountCtrl", ["$scope", "talentData", "$q", "$timeout", "State", "Entry", "User", "Presets", ($scope, talentData, $q, $timeout, State, Entry, User, Presets) ->

  $scope.state   = State
  $scope.presets = Presets.all
  $scope.entries = []
  $scope.page    = 1

  State.location = talentData.locations[0]

  fetch = (options={}) ->
    params =
      query:    State.query
      location: State.location?.name
      page:     $scope.page

    fetchEntries = ->
      fetching = $q.defer()
      Entry.query params, (data, parseHeaders) ->
        $scope.entries = if options.append then $scope.entries.concat(data) else data
        $scope.entriesTotal = parseInt parseHeaders()['tt-entriestotal']
        fetching.resolve()
      fetching.promise

    fetchSpecialists = ->
      fetching = $q.defer()
      User.query params, (data, parseHeaders) ->
        $scope.specialists = if options.append then $scope.specialists.concat(data) else data
        $scope.specialistsTotal = parseInt parseHeaders()['tt-specstotal']
        fetching.resolve()
      fetching.promise

    $scope.loadInProgress = true
    $q.all([fetchEntries(), fetchSpecialists()]).then ->
      $scope.loadInProgress = false


  $scope.$watch 'state.query', ->
    # if State.isEmpty()
    #   $scope.entries = $scope.specialists = []
    #   $scope.entriesTotal = $scope.specialistsTotal = 0
    if State.query
      $timeout (-> $scope.preloaderVisible = true if $scope.loadInProgress), 250
      fetch().then -> $scope.preloaderVisible = false

  $scope.$watch 'state.location', ->
    if State.query
      $timeout (-> $scope.preloaderVisible = true if $scope.loadInProgress), 250
      fetch().then -> $scope.preloaderVisible = false

  $scope.pickKeyword = (keyword) ->
    State.query = keyword

  $scope.fetchMore = ->
    if $scope.canFetchMore()
      $scope.page++
      fetch append: true

  $scope.canFetchMore = ->
    $scope.entries.length and $scope.entries.length < $scope.entriesTotal

]
