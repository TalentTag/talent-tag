@talent.controller "talent.LocationCtrl", ["$scope", "$q", "Location", "talentData", "$modal", ($scope, $q, Location, talentData, $modal) ->
  $scope.locations = _.map talentData.locations, (params) -> new Location params

  $scope.add = -> $scope.update new Location

  $scope.update = (place=null) ->

    modalInstance = $modal.open(
      animation: true,
      templateUrl: '/assets/modals/location.html.slim',
      controller: 'talent.EditLocationCtrl',
      size: 'sm',
      resolve: {
        place: -> return place
      }
    )

    modalInstance.result.then (newPlace) ->
      $scope.locations.push newPlace

  $scope.delete = (place) ->
    deleting = $q.defer()
    if confirm "Удалить?"
      place.$delete {}, -> deleting.resolve()
    deleting.promise.then ->
      $scope.locations = $scope.locations.filter (i) -> i isnt place
]

@talent.controller "talent.EditLocationCtrl", ["$scope", "$modalInstance", "place", ($scope, $modalInstance, place) ->
  $scope.currentPlace = place
  $scope.synonyms = place?.synonyms?.join("\n")

  $scope.save = (synonyms=[]) ->
    if synonyms.length
      $scope.currentPlace.synonyms  = synonyms.split("\n")

      if $scope.currentPlace.isPersisted()
        $scope.currentPlace.$update {}, ->
          $modalInstance.close($scope.currentPlace);
      else
        $scope.currentPlace.$save {}, ->
          $modalInstance.close($scope.currentPlace);

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')
]
