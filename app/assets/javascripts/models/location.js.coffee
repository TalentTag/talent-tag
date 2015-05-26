@talent.factory "Location", ["$resource", ($resource) ->

  $resource("/admin/locations/:id.json", { id: "@id" }, { update: { method: "PUT" } })

]
