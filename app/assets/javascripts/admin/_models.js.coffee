@talent.factory "Industry", ["$resource", ($resource) ->
  $resource("/admin/industries/:id.json", { id: "@id" }, { update: { method: "PUT" } })
]


@talent.factory "Area", ["$resource", ($resource) ->
  $resource("/admin/areas/:id.json", { id: "@id" }, { update: { method: "PUT" } })
]


@talent.factory "KeywordGroup", ["$resource", ($resource) ->
  _.tap $resource("/admin/keyword_groups/:id.json", { id: "@id" }, { update: { method: "PUT" } }), (KeywordGroup) ->
    KeywordGroup::isPersisted = -> @id?
]


@talent.factory "Entry", ["$resource", ($resource) ->
  $resource "/entries/:id.json", { id: "@id" }, { update: { method: "PUT" } }
]


@talent.factory "Source", ["$resource", ($resource) ->
  _.tap $resource("/admin/sources/:id.json", { id: "@id" }, { update: { method: "PUT" } }), (source) ->
    source::toggle = ->
      @hidden = !@hidden
      @$update()
]
