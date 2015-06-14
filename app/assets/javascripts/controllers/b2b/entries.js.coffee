@talent.controller "talent.EntriesCtrl", ["$scope", "Presets", ($scope, Presets) ->

  $scope.presets  = Presets.all

  $scope.group = 'entries'
  $scope.$on 'list:updated', (event, data) ->
  	$scope.group = if data.entries then 'entries' else 'specialists'

  if $scope.lastEntry
    _.defer ->
      element = document.getElementById "entry#{ $scope.lastEntry.id }"
      window.scrollTo 0, element.offsetTop - 70

      $scope.lastEntry = null

]
