@talent.factory "Location", ["$resource", ($resource) ->

  Location = $resource("/admin/locations/:id.json", { id: "@id" }, { update: { method: "PUT" } })

  Location::isPersisted = -> @id?

  Location
]
