@talent.directive "ttDrawer", ->
  templateUrl: '/assets/widgets/drawer.html.slim'
  scope: { title: '@ttDrawer' }
  transclude: true
