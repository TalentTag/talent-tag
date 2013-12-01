@talent.factory "KeywordGroupCollection", ["KeywordGroup", "talentData", (KeywordGroup, talentData) ->
  items: _.map talentData.keywordGroups, (params) ->
    new KeywordGroup params
  filter: (params={}) ->
    items = @items
    items = items.filter((kw) -> kw.industry_id is params.industry.id) if params.industry?
    items = items.filter((kw) -> kw.area_id is params.area.id) if params.area?
    items
  remove: (group) ->
    group.$delete {}
    @items = @items.filter (g) -> g isnt group
]
