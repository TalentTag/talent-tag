@talent.factory "User", ["$resource", ($resource) ->

  User = $resource "/users/:id.json", { id: "@id" },
    update:
      method: "PUT"
    search:
      url: "/users/:id/search.json"
      isArray: true

  User::location = ->
    @profile.location || @profile.city

  User

]
