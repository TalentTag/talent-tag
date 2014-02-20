@talent.controller "talent.AuthB2bCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.errors = {}

  $scope.toggleForgotCredentials = ->
    $scope.forgotCredentialsShown = !$scope.forgotCredentialsShown

  $scope.signin = ->
    $scope.errors = {}
    $http.post("/auth/signin.json", user: $scope.user, rememberme: $scope.rememberme).success( -> window.location = '/account' ).error (response) ->
      $scope.errors.credentials = response.credentials?[0]

  $scope.signup = ->
    $scope.errors = {}
    $http.post("/companies.json", company: { name: $scope.company.name, owner_attributes: $scope.newuser }).success( -> window.location = '/account' ).error (response) ->
      $scope.errors[key] = values[0] for key, values of response.errors

  $scope.forgot = ->
    $scope.errors = {}
    $http.post("/auth/forgot.json", { user: { email: $scope.email } }).success( -> window.location = '/' ).error (response) -> $scope.errors.email = response.errors?.email?[0]

]
