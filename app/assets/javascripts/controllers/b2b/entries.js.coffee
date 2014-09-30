@talent.controller "talent.EntriesCtrl", ["$scope", ($scope) ->

  if $scope.lastEntry
    _.defer ->
      element = document.getElementById "entry#{ $scope.lastEntry.id }"
      window.scrollTo 0, element.offsetTop - 70

      $scope.lastEntry = null

]
