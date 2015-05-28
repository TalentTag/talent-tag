@talent.factory "KeywordGroup", ["$resource", "talentData", ($resource, talentData) ->

  KWGroup = $resource("/admin/keyword_groups/:id.json", { id: "@id" }, { update: { method: "PUT" } })

  KWGroup.items = _.map talentData.keywordGroups, (params) -> new KWGroup params


  KWGroup::isPersisted = -> @id?

  KWGroup.filter = (params={}) ->
    items = @items
    items = items.filter((kw) -> kw.industry_id is params.industry.id) if params.industry?
    items = items.filter((kw) -> kw.area_id is params.area.id) if params.area?
    items

  KWGroup.remove = (group) ->
    group.$delete {}
    @items = @items.filter (g) -> g isnt group


  KWGroup

]
