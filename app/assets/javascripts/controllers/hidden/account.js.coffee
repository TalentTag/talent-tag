@talent.controller "talent.HiddenAccountCtrl", ["$scope", "talentData", "State", "Presets", ($scope, talentData, State, Presets) ->

  $scope.locations      = talentData.locations
  $scope.industries     = talentData.industries
  $scope.areas          = talentData.areas

  $scope.presets        = Presets.all

  $scope.activeTags     = []


  $scope.pickCatalogFolder = (folder) ->
    $scope.catalogFolder = folder
    $scope.query = $scope.currentIndustry = $scope.currentArea = null

  $scope.setIndustry = (industry) ->
    industry = _.findWhere(talentData.industries, name: industry)
    $scope.currentIndustry = industry

  $scope.setArea = (area) ->
    area = _.findWhere(talentData.areas, name: area)
    $scope.currentArea = area



  $scope.pickKeyword = (result) ->
    $scope.activeTags.push(result) unless result in $scope.activeTags
    $scope.query = ""

  $scope.pickLocation = (location) ->
    $scope.currentLocation = location
    $scope.query = ""

  $scope.pickQuery = (keyCode) ->
    if $scope.query? && keyCode is 13
      if location = _.find(talentData.locations, (location) -> location.toLowerCase() is $scope.query.toLowerCase())
        $scope.pickLocation(location)
      else
        $scope.pickKeyword($scope.query)

  $scope.dropTag = (tag) ->
    $scope.activeTags = _.without $scope.activeTags, tag



  $scope.locationsVisible = ->
    $scope.query || $scope.catalogFolder == 'locations'

  $scope.industriesVisible = ->
    !$scope.query && $scope.catalogFolder == 'industries'

  $scope.areasVisible = ->
    !$scope.query && $scope.catalogFolder == 'areas'


  filterKeywords = ->
    $scope.keywordGroups = if $scope.currentIndustry?
      talentData.keywordGroups.filter((kw) -> kw.industry_id is $scope.currentIndustry.id)
    else if $scope.currentArea?
      talentData.keywordGroups.filter((kw) -> kw.area_id is $scope.currentArea.id)
    else []
  $scope.$watch 'currentIndustry', filterKeywords
  $scope.$watch 'currentArea', filterKeywords

  compare = (string, substring) -> string.toLowerCase().indexOf(substring.toLowerCase()) is 0
  $scope.$watch 'query', (query) ->
    if query?.length
      $scope.keywordGroups    = talentData.keywordGroups.filter (kw) -> compare kw.keywords[0], query
      $scope.locations        = talentData.locations.filter (location) -> compare location, query
    else
      $scope.keywordGroups    = []
      $scope.locations        = talentData.locations
      $scope.currentIndustry  = null
      $scope.currentArea      = null

]
