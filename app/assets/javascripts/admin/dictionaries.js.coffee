talent.module.controller "talent.IndustryCtrl", ["$scope", "$http", ($scope, $http) ->
  $scope.industries = talent.industries

  $scope.add = ->
    $scope.error = null
    $http.post("/admin/industries", name: $scope.new_industry)
      .success( (industry) ->
        $scope.industries.push industry
        $scope.new_industry = null )
      .error( (data, status) -> $scope.error = data.errors.name[0] )

  $scope.update = (industry, $event) ->
    # TODO make up with a contenteditable directive
    $http.put("/admin/industries/#{ industry.id }", name: $($event.target).text())

  $scope.delete = (industry) ->
    if confirm "Удалить?"
      $http.delete("/admin/industries/#{ industry.id }").success ->
        $scope.industries = $scope.industries.filter (i) -> i isnt industry
]



talent.module.controller "talent.AreaCtrl", ["$scope", "$http", ($scope, $http) ->
  $scope.areas = talent.areas

  $scope.add = ->
    $scope.error = null
    $http.post("/admin/areas", name: $scope.new_area)
      .success( (area) ->
        $scope.areas.push area
        $scope.new_area = null )
      .error( (data, status) -> $scope.error = data.errors.name[0] )

  $scope.update = (area, $event) ->
    $http.put("/admin/areas/#{ area.id }", name: $($event.target).text())

  $scope.delete = (area) ->
    if confirm "Удалить?"
      $http.delete("/admin/areas/#{ area.id }").success ->
        $scope.areas = $scope.areas.filter (i) -> i isnt area
]



talent.module.controller "talent.KeywordGroupCtrl", ["$scope", "$http", ($scope, $http) ->
  $scope.industries = talent.industries
  $scope.areas = talent.areas
  $scope.keywordGroups = $scope.selectedKeywordGroups = talent.keywordGroups

  $scope.filter = ->
    $scope.selectedKeywordGroups = $scope.keywordGroups
    if $scope.industry?
      $scope.selectedKeywordGroups = $scope.selectedKeywordGroups.filter (kw) -> kw.industry_id is $scope.industry.id
    if $scope.area?
      $scope.selectedKeywordGroups = $scope.selectedKeywordGroups.filter (kw) -> kw.area_id is $scope.area.id
    $scope.pick()

  $scope.clear = -> $scope.pick()

  $scope.add = -> $scope.pick {}

  $scope.pick = (group=null) ->
    $scope.currentGroup     = group
    $scope.currentIndustry  = $scope.industries.filter( (i) -> group?.industry_id is i.id )?[0]
    $scope.currentArea      = $scope.areas.filter( (a) -> group?.area_id is a.id )?[0]
    $scope.keywords         = group?.keywords?.join("\n")

  $scope.save = ->
    keywords = $scope.keywords.split("\n")
    if keywords.length
      $scope.currentGroup.keywords     = keywords
      $scope.currentGroup.industry_id  = $scope.currentIndustry?.id
      $scope.currentGroup.area_id      = $scope.currentArea?.id
      (
        if $scope.currentGroup.id?
          $http.put("/admin/keyword_groups/#{ $scope.currentGroup.id }", $scope.currentGroup)
        else
          $http.post("/admin/keyword_groups", $scope.currentGroup).success -> $scope.keywordGroups.push $scope.currentGroup
      ).success -> $scope.pick()

  $scope.delete = (group) ->
    if confirm "Удалить?"
      $http.delete("/admin/keyword_groups/#{ group.id }").success ->
        $scope.keywordGroups = $scope.selectedKeywordGroups = $scope.keywordGroups.filter (g) -> g isnt group
]
