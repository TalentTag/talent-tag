#= require main
#= require_self
#= require_tree ./shared
#= require_tree ./admin


@talent = angular.module 'talent', ['ngResource', 'ng-rails-csrf']
@talent.value 'talentData', window.talentData
