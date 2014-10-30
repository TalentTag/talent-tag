@talent.controller "talent.AdminEntryCtrl", ["$scope", "Entry", "Source", ($scope, Entry, Source) ->

  $scope.sources = Source.filter()

  query = (config={}) ->
    Entry.query { source: $scope.source?.id, page: $scope.page, published: ($scope.publishedOnly || null) }, (data, parseHeaders) ->
      $scope.entries = if data.length
        $scope.entriesTotal = parseInt parseHeaders()['tt-entriestotal']
        if config.append then $scope.entries.concat(data) else data
      else []

  $scope.fetch = ->
    $scope.page = 1
    query()

  $scope.fetchMore = ->
    $scope.page = $scope.page + 1
    query append: true

  $scope.canFetchMore = -> $scope.entries?.length and $scope.entries.length < $scope.entriesTotal

  $scope.isNewEntry = (entry) ->
    new Date(entry.fetched_at) > $scope.lastLogin

  $scope.delete = (entry) ->
    if confirm "Удалить запись?"
      entry.$delete()
      $scope.entries = $scope.entries.filter (e) -> e isnt entry

  $scope.fetch()

]
