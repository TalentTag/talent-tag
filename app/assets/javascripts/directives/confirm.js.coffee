@talent.directive "ttConfirm", ->
  (scope, elem, attrs) ->
    elem.on 'click', ->
      scope.$apply(attrs.ngClick) if confirm(attrs.ttConfirm)
