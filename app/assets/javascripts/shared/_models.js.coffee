@talent.factory 'Message', ["$resource", ($resource) ->

  $resource "/account/messages/:id", { id: "@id" }

]
