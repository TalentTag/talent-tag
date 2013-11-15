#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.role
#= require maskedinput


$ ->

  $('form').on 'submit', -> $('.err', @).text ''

  $(document).on 'ajax:error', 'form', (event, xhr) ->
    if errors = JSON.parse(xhr.responseText)?.errors || JSON.parse(xhr.responseText)
      $.each errors, (field, messages) ->
        $("@#{ field }", event.target).text messages[0]

  $('input.phone').mask "+7(999)999-9999"


  $(document).on 'ajax:success', '@signup-form, @signin-form', ->
    window.location = '/account'

  $(document).on 'ajax:success', '@forgot-form', ->
    window.location = '/'
