@talent.factory 'Entry', ["$resource", ($resource) ->
  $resource "/entries/:id.json", { id: "@id" }, { update: { method: "PUT" } }
]
