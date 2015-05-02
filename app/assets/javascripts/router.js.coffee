@talent.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider.when '/',
    templateUrl: '/assets/entries.html.slim'
    controller: 'talent.EntriesCtrl'

  $routeProvider.when '/entries/:id',
    templateUrl: '/assets/details.html.slim'
    controller: 'talent.DetailsCtrl'

  $routeProvider.when '/folders/:id',
    templateUrl: '/assets/entries.html.slim'
    controller: 'talent.FoldersCtrl'


  $routeProvider.when '/account/conversations/:recipient_id',
    templateUrl: '/assets/conversation.html.slim'
    controller: 'talent.MessagesCtrl'

  $locationProvider.html5Mode(true)
]
