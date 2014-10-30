@talent.directive "ttTimer", ->

  transclude: true
  templateUrl: '/assets/widgets/timer.html.slim'
  scope: { company: "=" }

  link: (scope, elem, attrs) ->

    format = (time) ->
      "#{ Math.floor time/3600 }:#{ ("0" + Math.floor time%3600/60).slice(-2) }:#{ ("0" + Math.floor time%60).slice(-2) }"

    time = (new Date(scope.company.created_at).getTime() + 3*60*60*1000 - new Date().getTime()) / 1000
    scope.timeLeft = format time

    if time > 0
      tickTimer = ->
        if time <= 0
          window.location = '/' 
        else
          time--
          scope.$apply -> scope.timeLeft = format time unless time<0
      setInterval tickTimer, 1000
