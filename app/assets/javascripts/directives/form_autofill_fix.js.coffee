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
