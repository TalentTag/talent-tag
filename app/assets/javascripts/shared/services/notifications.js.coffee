@talent.service 'Notifications', ["$http", ($http) ->

  markChecked: ->
    $http.post "/account/notifications/mark_checked"

]
