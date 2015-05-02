@talent.controller "talent.CompleterCtrl", ["$scope", "talentData", "State", ($scope, talentData, State) ->

  $scope.state = State

  results = []
  focusIndex = -1


  $scope.pickKeyword = (keyword) ->
    State.addKeyword keyword
    $scope.activeTags = State.keywords
    $scope.query = ""

  $scope.pickLocation = (location) ->
    State.setLocation location
    $scope.currentLocation = State.location
    $scope.query = ""

  pickQuery = (query) ->
    if location = _.find(talentData.locations, (location) -> location.name.toLowerCase() is query.toLowerCase())
      $scope.pickLocation location
    else
      $scope.pickKeyword query

  $scope.resetState = ->
    $scope.keywordGroups = $scope.locations = []
    $scope.query = null
    State.clear()


  $scope.onKeyPress = (event) ->
    return unless $scope.query?
    unless event.keyCode in [13, 37, 38, 39, 40]
      tag.isFocused = false for tag in results
      focusIndex = -1
      return
    if event.keyCode is 13
      if focusIndex is -1 then pickQuery($scope.query) else pickQuery(if results[focusIndex].name? then results[focusIndex].name else results[focusIndex].keywords[0])
      focusIndex = -1
      return
    if results.length
      switch event.keyCode
        when 37, 38 then focusIndex-- unless focusIndex is 0
        when 39, 40 then focusIndex++ unless focusIndex is results.length-1
      tag.isFocused = false for tag in results
      results[focusIndex].isFocused = true

  compare = (string, substring) -> string.toLowerCase().indexOf(substring.toLowerCase()) is 0
  $scope.$watch 'query', (query) ->
    if query?.length
      # TODO sort by keywords[0]
      $scope.keywordGroups    = talentData.keywordGroups.filter (kw) -> compare kw.keywords[0], query
      $scope.locations        = talentData.locations.filter (location) -> compare location.name, query
      results                 = _.union $scope.locations, $scope.keywordGroups
    else
      $scope.keywordGroups    = []
      $scope.locations        = null
      results                 = []


  $scope.saveSearch = ->
    console.log (State.keywords.join(' ') + (if State.location? then " #{ State.location }" else "")).toLowerCase()

]
