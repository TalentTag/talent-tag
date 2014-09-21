@talent.controller "talent.KeywordsCtrl", ["$scope", "talentData", ($scope, talentData) ->
  $scope.industries     = talentData.industries
  $scope.areas          = talentData.areas
  $scope.keywordGroups  = talentData.keywordGroups

  $scope.$watch 'industry', (industry) ->
    $scope.groupsByIndustry = $scope.keywordGroups.filter((kw) -> kw.industry_id is industry.id) if industry?

  $scope.$watch 'area', (area) ->
    $scope.groupsByArea = $scope.keywordGroups.filter((kw) -> kw.area_id is area.id) if area?

  $scope.pick = (group) ->
    $scope.$parent.query = if $scope.$parent.query then "#{ $scope.$parent.query } #{ group.keywords[0] }" else group.keywords[0]
]
