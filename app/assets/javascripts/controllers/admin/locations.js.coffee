@talent.controller "talent.LocationCtrl", ["$scope", "$q", "Location", "talentData", ($scope, $q, Location, talentData) ->
  $scope.locations = _.map talentData.locations, (params) -> new Location params

  this.add = ->
    place = new Location name: $scope.new_place
    $scope.$parent.add(place).then ->
      $scope.locations.push place
      $scope.new_place = null

  this.update = (place, $event) ->
    place.name = $($event.target).text()
    place.$update()

  this.delete = (place) ->
    $scope.$parent.delete(place).then ->
      $scope.locations = $scope.locations.filter (i) -> i isnt place
]
