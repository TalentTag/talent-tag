@talent.controller "talent.EntriesCtrl", ["$scope", "$location", "$anchorScroll", ($scope, $location, $anchorScroll) ->

  if $scope.lastEntry
    $location.hash "entry#{ $scope.lastEntry.id }"
    $anchorScroll()

  $scope.lastEntry = null

]
