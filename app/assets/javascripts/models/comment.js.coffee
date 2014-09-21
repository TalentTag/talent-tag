@talent.factory 'Comment', ["$resource", ($resource) ->

  $resource "/entries/:entry_id/comments/:id.json", { entry_id: '@entry_id', id: '@id' }, { update: { method: "PUT" } }

]
