#= require main
#= require_self
#= require_tree ./admin


@talent = angular.module 'talent', ['ngResource']
@talent.value 'talentData', window.talentData
