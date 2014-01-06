@talent.factory 'Entry', ["$resource", "$http", ($resource, $http) ->
  Entry = $resource "/entries/:id.json", { id: "@id" }, { update: { method: "PUT" } }
  Entry::blacklist = -> $http.post "/entries/#{ @id }/blacklist.json"
  Entry
]


@talent.factory 'Search', ["$resource", ($resource) ->
  $resource "/searches/:id.json", { id: "@id" }, { update: { method: "PUT" } }
]


@talent.factory 'Folder', ["$resource", "$http", ($resource, $http) ->
  Folder = $resource "/folders/:id.json", { id: "@id" }, { update: { method: "PUT" } }
  Folder::addEntry    = (entry) -> $http.put "/folders/#{ @id }/add_entry.json", entry_id: entry.id
  Folder::removeEntry = (entry) -> $http.put "/folders/#{ @id }/remove_entry.json", entry_id: entry.id
  Folder
]
