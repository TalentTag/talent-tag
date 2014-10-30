@talent.directive "ttContenteditable", ->

  scope: { ttContenteditable: '=', target: '@' }

  link: (scope, elem, attrs) ->
    _.defer ->
      target = angular.element(scope.target).eq(0)
      elem.on 'click', ->
        target.focus()
      target.on 'blur', ->
        unless scope.ttContenteditable.text is target.text()
          scope.ttContenteditable.text = target.text()
          scope.ttContenteditable.$update()
          target.addClass('highlighted') # blink effect
          setTimeout (-> target.removeClass('highlighted')), 300
      target.on 'keypress' , (e) -> e.which isnt 13 # prevent new lines
