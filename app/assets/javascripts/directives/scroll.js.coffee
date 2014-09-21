@talent.directive "ttScroll", ->
  (scope, element, attrs) ->
    angular.element(window).bind "scroll", ->
      if this.pageYOffset < attrs.ttScroll then element.hide() else element.show()
