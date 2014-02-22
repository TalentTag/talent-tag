@talent.controller "talent.AuthCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.errors = {}

  $scope.toggleForgotCredentials = ->
    $scope.forgotCredentialsShown = !$scope.forgotCredentialsShown

  $scope.user = {}
  $scope.signin = ->
    $scope.errors = {}
    $http.post("/auth/signin.json", user: $scope.user, rememberme: $scope.rememberme).success( -> window.location = '/account' ).error (response) ->
      $scope.errors.credentials = response.credentials?[0]

  $scope.company = $scope.newuser = {}
  $scope.signup = ->
    $scope.errors = {}
    $http.post("/companies.json", company: { name: $scope.company.name, owner_attributes: $scope.newuser }).success( -> window.location = '/account' ).error (response) ->
      $scope.errors[key] = values[0] for key, values of response.errors

  $scope.forgot = ->
    $scope.errors = {}
    if $scope.email
      $http.post("/auth/forgot.json", { user: { email: $scope.email } }).success( -> window.location = '/' ).error (response) -> $scope.errors.email = response.errors?.email?[0]
    else
      $scope.errors.email = "Укажите e-mail"

]
