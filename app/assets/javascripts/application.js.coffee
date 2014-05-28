#= require main

#= require maskedinput
#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
#= require angular-route
#= require angular-sanitize

#= require_self
#= require_tree ./shared
#= require_tree ./b2b
#= require_tree ./b2c


@talent = angular.module 'talent', ['ngResource', 'ng-rails-csrf', 'ngRoute', 'ngSanitize', 'ui.bootstrap']
@talent.value 'talentData', window.talentData
