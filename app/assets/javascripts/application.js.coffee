#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.role
#= require maskedinput

#= require underscore
#= require angular
#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
#= require angular-resource
#= require angular-route

#= require_self
#= require_tree ./shared
#= require_tree ./application


@talent = angular.module 'talent', ['ngResource', 'ngRoute', 'ui.bootstrap']
@talent.value 'talentData', window.talentData
