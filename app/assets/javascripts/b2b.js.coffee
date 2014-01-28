#= require main

#= require maskedinput
#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
#= require angular-route

#= require_self
#= require_tree ./shared
#= require_tree ./b2b


@talent = angular.module 'talent', ['ngResource', 'ngRoute', 'ui.bootstrap']
@talent.value 'talentData', window.talentData


$ ->

  $('input.phone').mask "+7(999)999-9999"

  $(document).on 'ajax:success', '@signup-form, @signin-form', ->
    window.location = '/account'

  $(document).on 'ajax:success', '@forgot-form', ->
    window.location = '/'

