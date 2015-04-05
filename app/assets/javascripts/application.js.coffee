#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.role

#= require underscore
#= require angular
#= require angular-resource

#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
#= require angular-route
#= require angular-sanitize
#= require ngInfiniteScroll
#= require maskedinput
#= require moment
#= require moment/ru.js
#= require i18n

#= require danthes
# Danthes.debug = true # Breaks angular auth controller

#= require_self
#= require_tree ./controllers
#= require_tree ./directives
#= require_tree ./filters
#= require_tree ./models
#= require_tree ./services
#= require_tree ./utils

@talent = angular.module 'talent', ['ngResource', 'ngRoute', 'ngSanitize', 'ui.bootstrap', 'infinite-scroll']
@talent.value 'talentData', window.talentData
@talent.value 'Danthes', Danthes

# TODO refactor
$ ->

  $('form').on 'submit', -> $('.err', @).text ''

  $(document).on 'ajax:error', 'form', (event, xhr) ->
    if errors = JSON.parse(xhr.responseText)?.errors || JSON.parse(xhr.responseText)
      $.each errors, (field, messages) ->
        $("@#{ field }", event.target).text messages[0]


  $('#signup-b2c .modal-toggle').click ->
    $('.modal').modal('hide')
    $('.modal#signup-b2b').modal('show')

  $('#signup-b2b .modal-toggle').click ->
    $('.modal').modal('hide')
    $('.modal#signup-b2c').modal('show')
