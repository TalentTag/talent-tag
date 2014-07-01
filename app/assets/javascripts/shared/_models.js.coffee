@talent.factory 'Message', ["$resource", ($resource) ->

  $resource "/account/conversations/:conversation_id/messages/:id", { id: "@id", conversation_id: "@conversation_id" }

]
