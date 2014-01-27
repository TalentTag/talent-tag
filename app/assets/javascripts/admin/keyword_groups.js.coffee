@talent.controller "talent.KeywordGroupCtrl", ["$scope", "$location", "$anchorScroll", "KeywordGroup", "KeywordGroupCollection", ($scope, $location, $anchorScroll, KeywordGroup, KeywordGroupCollection) ->
  $scope.keywordGroups = KeywordGroupCollection.items

  $scope.filter = ->
    $scope.keywordGroups = KeywordGroupCollection.filter industry: $scope.industry, area: $scope.area
    $scope.clear()

  $scope.clear = -> $scope.focusOn null

  $scope.add = -> $scope.focusOn new KeywordGroup

  $scope.focusOn = (group=null) ->
    $scope.currentGroup     = group
    $scope.currentIndustry  = _.find $scope.industries, (i) -> group?.industry_id is i.id
    $scope.currentArea      = _.find $scope.areas, (a) -> group?.area_id is a.id
    $scope.keywords         = group?.keywords?.join("\n")
    $location.hash 'editarea'
    $anchorScroll()

  $scope.save = ->
    keywords = $scope.keywords.split("\n")
    if keywords.length
      $scope.currentGroup.keywords     = keywords
      $scope.currentGroup.industry_id  = $scope.currentIndustry?.id
      $scope.currentGroup.area_id      = $scope.currentArea?.id
      if $scope.currentGroup.isPersisted()
        $scope.currentGroup.$update {}, -> $scope.clear()
      else
        $scope.currentGroup.$save {}, ->
          $scope.keywordGroups.push $scope.currentGroup
          $scope.clear()

  $scope.delete = (group) ->
    if confirm "Удалить?"
      KeywordGroupCollection.remove(group)
      $scope.keywordGroups = KeywordGroupCollection.items
]
