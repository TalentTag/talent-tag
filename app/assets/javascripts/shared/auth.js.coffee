@talent.controller "talent.AuthCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.errors = {}
  $scope.user = $scope.company = $scope.newuser = {}

]


@talent.controller "talent.AuthB2bCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.signin = ->
    $scope.errors = {}
    $http.post("/auth/signin.json", user: $scope.user, rememberme: $scope.rememberme).success( -> window.location = '/account' ).error (response) ->
      $scope.errors.credentials = response.credentials?[0]

  $scope.signup = ->
    $scope.errors = {}
    $http.post("/companies.json", company: { name: $scope.company.name, owner_attributes: $scope.newuser }).success( -> window.location = '/account' ).error (response, status) ->
      return $scope.tab = 'add-company' if status is 403
      $scope.errors[key] = values[0] for key, values of response.errors

  $scope.forgot = ->
    $scope.errors = {}
    $http.post("/auth/forgot.json", { user: { email: $scope.email } }).success( -> window.location = '/' ).error (response) -> $scope.errors.email = response.errors?.email?[0]

]


@talent.controller "talent.AuthB2cCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.signin = ->
    $scope.errors = {}
    $http.post("/auth/signin.json", user: $scope.user, rememberme: $scope.rememberme).success( -> window.location = '/specialist/account' ).error (response) ->
      $scope.errors.credentials = response.credentials?[0]

  $scope.signup = ->
    $scope.errors = {}
    $http.post("/users.json", user: $scope.newuser).success( -> window.location = '/specialist/account' ).error (response) ->
      $scope.errors[key] = values[0] for key, values of response.errors

  $scope.forgot = ->
    $scope.errors = {}
    $http.post("/auth/forgot.json", { user: { email: $scope.email } }).success( -> window.location = '/' ).error (response) -> $scope.errors.email = response.errors?.email?[0]

]
