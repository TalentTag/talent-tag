@talent.directive "ttRemoteForm", ->
  (scope, elem, attrs) ->
    elem.on 'ajax:error', (e, xhr) ->
      elem.find('.form-error').html(xhr.responseText)
    elem.on 'ajax:success', (e, response) ->
      window.location.href = '/'
