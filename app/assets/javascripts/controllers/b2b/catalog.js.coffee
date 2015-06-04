@talent.controller "talent.CatalogCtrl", ["$scope", "talentData", "State", ($scope, talentData, State) ->

  $scope.industries     = talentData.industries
  $scope.areas          = talentData.areas
  $scope.keywordGroups  = talentData.keywordGroups

  $scope.$watch 'industry', (industry) ->
    $scope.groupsByIndustry = $scope.keywordGroups.filter((kw) -> kw.industry_id is industry.id) if industry?

  $scope.$watch 'area', (area) ->
    $scope.groupsByArea = $scope.keywordGroups.filter((kw) -> kw.area_id is area.id) if area?

  $scope.pick = (group) ->
    State.init query: group.keywords[0]

]
