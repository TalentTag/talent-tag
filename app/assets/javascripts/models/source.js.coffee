@talent.factory "Source", ["$resource", "talentData", ($resource, talentData) ->

  Source = $resource("/admin/sources/:id.json", { id: "@id" }, { update: { method: "PUT" } })

  items = _.map talentData.sources, (params) -> new Source params


  Source.filter = (state=null) ->
    switch state
      when 'public' then _.reject(items, (source) -> source.hidden)
      when 'hidden' then _.filter(items, (source) -> source.hidden)
      else items

  Source::toggle = ->
    @hidden = !@hidden
    @$update()


  Source

]
