@talent.factory "Area", ["$resource", ($resource) ->

  $resource("/admin/areas/:id.json", { id: "@id" }, { update: { method: "PUT" } })

]
