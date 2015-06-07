@talent.controller "talent.CompleterCtrl", ["$scope", "$window", "talentData", "State", "Search", ($scope, $window, talentData, State, Search) ->

  $scope.results  = []
  $scope.log      = []
  focusIndex      = -1


  angular.element($window).on 'keydown', (event) ->
    if $scope.results.length
      switch event.keyCode
        when 13
          if focusIndex>-1
            if $scope.keywordsVisible
              $scope.pickKeyword $scope.results[focusIndex].keywords[0]
            else if $scope.locationsVisible
              $scope.pickLocation $scope.results[focusIndex]
              resetResults()
        when 37, 38 then focusIndex-- unless focusIndex is 0
        when 39, 40 then focusIndex++ unless focusIndex is $scope.results.length-1
      if focusIndex>-1
        tag.isFocused = false for tag in $scope.results
        $scope.results[focusIndex].isFocused = true
      $scope.$apply()

  compare = (string, substring) ->
    string.toLowerCase().indexOf(substring.toLowerCase()) is 0

  resetResults = ->
    tag.isFocused           = false for tag in $scope.results
    focusIndex              = -1
    $scope.results          = []
    $scope.keywordsVisible  = false
    $scope.locationsVisible = false


  # keywords
  $scope.pickKeyword = (query) ->
    State.init {query}

  $scope.pickQuerystring = (keyCode) ->
    $scope.pickKeyword($scope.query) if keyCode is 13 and focusIndex is -1

  $scope.$watch 'state.query', ->
    $scope.query = State.query

  $scope.$watch 'query', (query) ->
    if query
      $scope.results = $scope.keywordGroups = talentData.keywordGroups.filter (kw) -> compare(kw.keywords[0], query)
    else
      State.init { query: "" }
    $scope.keywordsVisible = query?.length and $scope.keywordGroups.length and query isnt State.query


  # locations
  $scope.toggleLocations = ->
    $scope.locationsVisible = !$scope.locationsVisible
    $scope.results = $scope.locations = talentData.locations

  $scope.$watch 'location', (location) ->
    $scope.results = $scope.locations = if location
      talentData.locations.filter (l) -> compare(l.name, location)
    else talentData.locations

  $scope.pickLocation = (location) ->
    State.init {location}
    _.defer -> $scope.locationsVisible = false

  $scope.pickLocationstring = (keyCode) ->
    State.init location: {name: $scope.location} if keyCode is 13 and focusIndex is -1

  $scope.clearLocation = ->
    State.init location: {}


  # logging & stored searches
  State.onChange ->
    if State.query
      search = _.clone(State)
      $scope.log.push(search) unless search.in $scope.log
    resetResults()

  $scope.restoreSearch = (search) ->
    $scope.pickKeyword search.query
    $scope.pickLocation search.location

  $scope.storeSearch = (search) ->
    Search.add search.query, location: search.location?.name
    $scope.log = _.without $scope.log, search

  $scope.forgetSearch = (search) ->
    $scope.log = _.without $scope.log, search

  $scope.storeLog = ->
    $scope.storeSearch(search) for search in $scope.log # TODO make a bulk save

  $scope.clearLog = ->
    $scope.log = []
    State.clear()

]
