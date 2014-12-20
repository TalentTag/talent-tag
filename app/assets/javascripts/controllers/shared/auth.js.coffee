@talent.controller "talent.AuthCtrl", ["$scope", "$http", ($scope, $http) ->

  account_types =
    b2b: 'employer'
    b2c: 'specialist'

  reset_errors = ->
    $scope.errors = {}

  $scope.signin = (scope) ->
    reset_errors()
    signin = $http.post "/auth/signin.json", user: $scope.user, rememberme: $scope.rememberme, type: account_types[scope]
    signin.success -> window.location = '/'
    signin.error (response) -> $scope.errors.credentials = response.credentials?[0]

  $scope.signup_b2b = ->
    reset_errors()
    signup = $http.post "/companies.json", company: { name: $scope.company.name, owner_attributes: $scope.newuser }
    signup.success -> window.location = '/'
    signup.error (response, status) ->
      return $scope.tab = 'add-company' if status is 403
      $scope.errors[key] = values[0] for key, values of response.errors

  $scope.signup_b2c = ->
    reset_errors()
    signup = $http.post("/users.json", user: $scope.newuser, type: account_types.b2c)
    signup.success -> window.location = '/'
    signup.error (response) -> $scope.errors[key] = values[0] for key, values of response.errors

  $scope.forgot = (scope) ->
    reset_errors()
    forgot = $http.post "/auth/forgot.json", { user: { email: $scope.email }, type: account_types[scope] }
    forgot.success -> window.location.reload()
    forgot.error (response) -> $scope.errors.email = response.errors?.email?[0]

]
