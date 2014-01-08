@talent.factory 'SearchesCollection', ["Search", "talentData", (Search, talentData) ->
  items: _.map(talentData.searches, (params) -> new Search params)

  add: (query) ->
    _.tap new Search(name: query, query: query), (search) =>
      @items.push search
      search.$save()

  remove: (search) ->
    @items = _.reject @items, (s) -> search is s
    search.$remove()
]


@talent.factory 'FoldersCollection', ["Folder", "$q", "talentData", (Folder, $q, talentData) ->
  items: _.map(talentData.folders, (params) -> new Folder params)

  load: (folder) ->
    loading = $q.defer()
    Folder.get id: folder.id, (folder) -> loading.resolve folder
    loading.promise

  add: (name) ->
    saving = $q.defer()
    _.tap new Folder({ name }), (folder) =>
      @items.push folder
      folder.$save -> saving.resolve folder
    saving.promise

  remove: (folder) ->
    @items = _.reject @items, (f) -> folder is f
    folder.$remove()
]
