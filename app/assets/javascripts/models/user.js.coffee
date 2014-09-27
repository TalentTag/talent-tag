@talent.factory "User", ["$resource", ($resource) ->

  $resource "/users/:id.json", { id: "@id" },
    update:
      method: "PUT"
    search:
      url: "/users/:id/search.json"
      isArray: true

]
