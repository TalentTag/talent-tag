@talent.controller 'talent.PortfolioCtrl', ["$scope", "talentData", "$http", ($scope, talentData, $http) ->

  $scope.portfolio = talentData.portfolio

  $scope.postLink = (link) ->
    $http.post("/account/portfolio/", link).success (response) ->
      link.id = response.id
    $scope.portfolio.push link
    $scope.newLink = {}
    $scope.displayPortfolioForm = false

  $scope.deleteLink = (link) ->
    if confirm "Удалить ссылку из портфолио?"
      $http.delete "/account/portfolio/#{ link.id }"
      $scope.portfolio = _.without $scope.portfolio, link

]
