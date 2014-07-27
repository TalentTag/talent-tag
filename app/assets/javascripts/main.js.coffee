#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.role

#= require underscore
#= require angular
#= require angular-resource
#= require ng-rails-csrf
#= require ngInfiniteScroll


$ ->

  $('form').on 'submit', -> $('.err', @).text ''

  $(document).on 'ajax:error', 'form', (event, xhr) ->
    if errors = JSON.parse(xhr.responseText)?.errors || JSON.parse(xhr.responseText)
      $.each errors, (field, messages) ->
        $("@#{ field }", event.target).text messages[0]
