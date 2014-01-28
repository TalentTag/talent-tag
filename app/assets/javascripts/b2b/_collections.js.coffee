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


@talent.factory 'FoldersCollection', ["Folder", "Entry", "$q", "talentData", (Folder, Entry, $q, talentData) ->
  items: _.map(talentData.folders, (params) -> new Folder params)

  load: (id) ->
    loading = $q.defer()
    Folder.fetch id, (entries) -> loading.resolve _.map(entries, (params) -> new Entry params)
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
