@talent.controller "talent.DictionaryCtrl", ["$scope", "$q", "Industry", "Area", "talentData", ($scope, $q, Industry, Area, talentData) ->
  $scope.industries = _.map talentData.industries, (params) -> new Industry params
  $scope.areas      = _.map talentData.areas, (params) -> new Area params

  $scope.add = (dictionary) ->
    adding = $q.defer()
    $scope.error = null
    callback = (dictionary) ->
      adding.resolve dictionary
    errback  = (error) ->
      $scope.error = error.data.errors.name[0]
      adding.reject error
    dictionary.$save {}, callback, errback
    adding.promise

  $scope.update = (dictionary, $event) ->
    dictionary.name = $($event.target).text()
    dictionary.$update()

  $scope.delete = (dictionary) ->
    deleting = $q.defer()
    if confirm "Удалить?"
      dictionary.$delete {}, -> deleting.resolve()
    deleting.promise
]


@talent.controller "talent.IndustryCtrl", ["$scope", "Industry", ($scope, Industry) ->
  $scope.add = ->
    industry = new Industry name: $scope.new_industry
    $scope.$parent.add(industry).then ->
      $scope.industries.push industry
      $scope.new_industry = null

  $scope.delete = (industry) ->
    $scope.$parent.delete(industry).then ->
      $scope.industries = $scope.industries.filter (i) -> i isnt industry
]


@talent.controller "talent.AreaCtrl", ["$scope", "Area", ($scope, Area) ->
  $scope.add = ->
    area = new Area name: $scope.new_area
    $scope.$parent.add(area).then ->
      $scope.areas.push area
      $scope.new_industry = null

  $scope.delete = (area) ->
    $scope.$parent.delete(area).then ->
      $scope.areas = $scope.areas.filter (i) -> i isnt area
]
