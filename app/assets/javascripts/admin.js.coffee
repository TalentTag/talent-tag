#= require jquery
#= require twitter/bootstrap
#= require underscore
#= require angular
#= require angular-resource
#= require_self
#= require_tree ./shared
#= require_tree ./admin

@talent = angular.module 'talent', ['ngResource']
@talent.value 'talentData', window.talentData
