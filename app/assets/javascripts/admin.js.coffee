#= require jquery
#= require twitter/bootstrap
#= require underscore
#= require angular
#= require angular-resource
#= require_self
#= require_tree ./admin

@talent = angular.module 'talent', ['ngResource']
@talent.value 'talentData', talentData
