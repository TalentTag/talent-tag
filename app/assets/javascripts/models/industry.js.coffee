@talent.factory "Industry", ["$resource", ($resource) ->

  $resource("/admin/industries/:id.json", { id: "@id" }, { update: { method: "PUT" } })

]
