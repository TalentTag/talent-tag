@talent.controller "talent.AccountCtrl", ["$scope", "Entry", "talentData", ($scope, Entry, talentData) ->
  $scope.entries  = []
  $scope.page     = 1
  $scope.query    = ''
  $scope.keywords = _.map talentData.keywordGroups, (group) -> group.keywords[0]

  query = (config={}) ->
    if $scope.query
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
]
