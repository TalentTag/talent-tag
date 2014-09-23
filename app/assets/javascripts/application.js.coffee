#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.role

#= require underscore
#= require angular
#= require angular-resource
#= require ng-rails-csrf

#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
#= require angular-route
#= require angular-sanitize
#= require ngInfiniteScroll
#= require maskedinput
#= require moment
#= require moment/ru.js

#= require danthes
# Danthes.debug = true # Breaks angular auth controller

#= require_self
#= require_tree ./controllers
#= require_tree ./directives
#= require_tree ./filters
#= require_tree ./models
#= require_tree ./services


@talent = angular.module 'talent', ['ngResource', 'ng-rails-csrf', 'ngRoute', 'ngSanitize', 'ui.bootstrap', 'infinite-scroll']
@talent.value 'talentData', window.talentData
@talent.value 'Danthes', Danthes



# TODO refactor
$ ->

  $('form').on 'submit', -> $('.err', @).text ''

  $(document).on 'ajax:error', 'form', (event, xhr) ->
    if errors = JSON.parse(xhr.responseText)?.errors || JSON.parse(xhr.responseText)
      $.each errors, (field, messages) ->
        $("@#{ field }", event.target).text messages[0]
