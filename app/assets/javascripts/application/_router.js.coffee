@talent.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider.when '/account',
    templateUrl: '/assets/entries.html.slim'
    controller: 'talent.EntriesCtrl'

  $routeProvider.when '/account/entries/:id',
    templateUrl: '/assets/details.html.slim'
    controller: 'talent.DetailsCtrl'

  $routeProvider.when '/account/folders/:id',
    templateUrl: '/assets/entries.html.slim'
    controller: 'talent.FoldersCtrl'

  $routeProvider.otherwise redirectTo: '/account'

  $locationProvider.html5Mode(true)
]
