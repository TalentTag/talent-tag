@talent.controller "talent.CompleterCtrl", ["$scope", "$window", "talentData", "State", ($scope, $window, talentData, State) ->

  $scope.results  = []
  $scope.log      = []
  focusIndex      = -1


  resetResults = ->
    tag.isFocused = false for tag in $scope.results
    $scope.focusedOn = undefined
    focusIndex = -1

  angular.element($window).on 'keydown', (event) ->
    if $scope.results.length
      return resetResults() unless event.keyCode in [13, 37, 38, 39, 40]
      switch event.keyCode
        when 13
          if focusIndex>-1
            if $scope.focusedOn is 'keywords'
              $scope.pickKeyword $scope.results[focusIndex].keywords[0]
            else if $scope.focusedOn is 'locations'
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


  # keywords
  $scope.$watch 'query', (query) ->
    $scope.focusedOn = if query?.length
      $scope.results = $scope.keywordGroups = talentData.keywordGroups.filter (kw) -> compare(kw.keywords[0], query)
      'keywords'
    else undefined

  $scope.pickKeyword = (keyword) ->
    $scope.query = State.query = keyword

  $scope.pickQuerystring = (keyCode) ->
    if keyCode is 13 and focusIndex is -1
      State.query = $scope.query


  # locations
  $scope.toggleLocations = ->
    $scope.focusedOn = if $scope.focusedOn isnt 'locations'
      $scope.results = $scope.locations = talentData.locations
      'locations'
    else undefined

  $scope.$watch 'location', (location) ->
    $scope.results = $scope.locations = if location
      talentData.locations.filter (l) -> compare(l.name, location)
    else talentData.locations

  $scope.pickLocation = (location) ->
    State.location = location
    $scope.location = undefined

  $scope.pickLocationstring = (keyCode) ->
    State.location = {name: $scope.location} if keyCode is 13 and focusIndex is -1


  # logging
  log = ->
    if State.query
      # $scope.query = State.query unless State.query is $scope.query
      search = _.clone(State)
      $scope.log.push(search) unless search in $scope.log
    resetResults()
  $scope.$watch 'state.query', log
  $scope.$watch 'state.location', log

  $scope.storeSearch = (search) ->
    alert "Сохраняю '#{ search }'"

  $scope.forgetSearch = (search) ->
    $scope.log = _.without $scope.log, search

  $scope.storeLog = ->
    alert "Сохраняю лог, запросов: #{ $scope.log.length }"

  $scope.clearLog = ->
    $scope.log = []
    State.query = $scope.query = ""

]
