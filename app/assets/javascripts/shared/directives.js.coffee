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
