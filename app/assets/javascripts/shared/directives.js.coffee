@talent.directive "ttScroll", ->
  (scope, element, attrs) ->
    angular.element(window).bind "scroll", ->
      if this.pageYOffset < attrs.ttScroll then element.hide() else element.show()


@talent.directive "ttMask", ->
  (scope, element, attrs) ->
    $(element).mask attrs.ttMask


@talent.directive "ttFormAutofillFix", ->
  (scope, elem, attrs) ->
    elem.prop 'method', 'POST'
    if attrs.ngSubmit
      setTimeout ( ->
        elem.unbind('submit').submit (e) ->
          e.preventDefault()
          elem.find('input, textarea, select').trigger('input').trigger('change').trigger('keydown')
          scope.$apply attrs.ngSubmit
      ), 0


@talent.directive "ttRemoteForm", ->
  (scope, elem, attrs) ->
    elem.on 'ajax:error', (e, xhr) ->
      elem.find('.form-error').html(xhr.responseText)
    elem.on 'ajax:success', (e, response) ->
      window.location.href = '/'


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
