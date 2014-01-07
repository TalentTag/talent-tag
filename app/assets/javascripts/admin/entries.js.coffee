@talent.controller "talent.EntryCtrl", ["$scope", "Entry", "talentData", ($scope, Entry, talentData) ->
  $scope.sources    = talentData.sources
  $scope.entries    = talentData.entries
  $scope.totalPages = talentData.totalPages
  $scope.page       = 1

  query = (config={}) ->
    Entry.query { source: $scope.source?.id, page: $scope.page, published: ($scope.publishedOnly || null) }, (data, parseHeaders) ->
      $scope.entries = if data.length
        $scope.totalPages = parseInt parseHeaders()["tt-pagecount"]
        if config.append then $scope.entries.concat(data) else data
      else []

  $scope.fetch = ->
    $scope.page = 1
    query()

  $scope.fetchMore = ->
    $scope.page = $scope.page + 1
    query append: true

  $scope.isLastPage = -> $scope.page is $scope.totalPages

  $scope.isNewEntry = (entry) ->
    new Date(entry.created_at) > $scope.lastLogin

  $scope.range = (num) -> [1 .. num]
]
