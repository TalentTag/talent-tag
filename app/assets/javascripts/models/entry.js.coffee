@talent.factory 'Entry', ["$resource", ($resource) ->

  Entry = $resource "/entries/:id.json", { id: "@id" }, { update: { method: "PUT" } }

  Entry::hasProfile = -> @author and @author.profile? and not _.isEmpty @author.profile

  Entry

]
