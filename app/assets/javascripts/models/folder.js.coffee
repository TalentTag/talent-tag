@talent.factory 'Folder', ["$resource", "$http", "$q", "talentData", "Entry", ($resource, $http, $q, talentData, Entry) ->

  Folder = $resource "/folders/:id.json", { id: "@id" }, { update: { method: "PUT" } }

  Folder.items = _.map talentData.folders, (params) -> new Folder params


  Folder.add = (name) ->
    saving = $q.defer()
    _.tap new Folder({ name }), (folder) =>
      Folder.items.push folder
      folder.$save -> saving.resolve folder
    saving.promise

  Folder.load = (id, callback) ->
    $http.get("/entries.json?folder_id=#{ id }").then (response) ->
      callback response.data.map (params) -> new Entry params

  Folder::addEntry    = (entry) ->
    $http.put "/folders/#{ @id }/add_entry.json", entry_id: entry.id
    @entries.push entry.id

  Folder::removeEntry = (entry) -> $http.put "/folders/#{ @id }/remove_entry.json", entry_id: entry.id

  Folder::contains = (entry) -> entry.id in @entries if @entries? and entry?


  Folder

]
