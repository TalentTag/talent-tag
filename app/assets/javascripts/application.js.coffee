#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.role
#= require_tree .


$ ->

  $('form').on 'submit', -> $('.err', @).text ''

  $(document).on 'ajax:error', 'form', (event, xhr) ->
    if errors = JSON.parse(xhr.responseText)?.errors || JSON.parse(xhr.responseText)
      $.each errors, (field, messages) ->
        $("@#{ field }", event.target).text messages[0]


  $(document).on 'ajax:success', '@signup-form, @signin-form', ->
    window.location = '/account'

  $(document).on 'ajax:success', '@forgot-form', ->
    window.location = '/'
