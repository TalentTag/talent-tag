@talent.controller "talent.PremiumCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.user               = talentData.user
  $scope.user.isDetailed    = -> _.every [@firstname?, @lastname?, @phone?]

  $scope.company            = talentData.company
  $scope.company.isDetailed = -> _.every [@website?, @phone?, @address?, @details?]

  steps =
    intro:        1
    userform:     2
    companyform:  3
    payment:      4
  $scope.step = steps.intro

  $scope.errors = {}
  parseErrors = (response) ->
    $scope.errors[key] = values[0] for key, values of response.errors

  $scope.nextStep = ->
    $scope.step++
    $scope.nextStep() if $scope.step is steps.userform and $scope.user.isDetailed()
    $scope.nextStep() if $scope.step is steps.companyform and $scope.company.isDetailed()

  $scope.saveUserData = ->
    $scope.errors = {}
    $scope.user.phone = $('@user-form').find('[name=phone]').val() # @TODO get gid of it
    $http.put("/users/#{ $scope.user.id }.json", user: $scope.user).success( -> $scope.nextStep() ).error(parseErrors)

  $scope.saveCompanyData = ->
    $scope.errors = {}
    $scope.company.phone = $('@company-form').find('[name=phone]').val() # @TODO get gid of it
    $http.put("/companies/#{ $scope.company.id }.json", company: $scope.company).success( -> $scope.nextStep() ).error(parseErrors)
    
  $scope.buy = ->
    $http.put("/companies/#{ $scope.company.id }/update_to_premium.json", { rate: $scope.premiumRate }).success -> window.location.reload()

]
