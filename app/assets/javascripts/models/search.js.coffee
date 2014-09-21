@talent.factory 'Search', ["$resource", "$http", "talentData", ($resource, $http, talentData) ->

  Search = $resource "/searches/:id.json", { id: "@id" }, { update: { method: "PUT" } }

  Search.items = _.map talentData.searches, (params) -> new Search params


  Search.add = (query) ->
    _.tap new Search(name: query, query: query), (search) =>
      @items.push search
      search.$save()

  Search.remove = (search) ->
    @items = _.reject @items, (s) -> search is s
    search.$remove()

  Search::blacklist = (entry) -> $http.post "/searches/#{ @id }/blacklist/#{ entry.id }.json"


  Search

]
