@talent.directive "ttMask", ->
  (scope, element, attrs) ->
    $(element).mask attrs.ttMask
