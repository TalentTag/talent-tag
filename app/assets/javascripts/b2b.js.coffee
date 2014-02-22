#= require main

#= require maskedinput
#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
#= require angular-route

#= require_self
#= require_tree ./shared
#= require_tree ./b2b


@talent = angular.module 'talent', ['ngResource', 'ng-rails-csrf', 'ngRoute', 'ui.bootstrap']
@talent.value 'talentData', window.talentData
