@talent.service 'State', ->

  query: ''
  location: null

  isEmpty: ->
    _.isEmpty @query
    # _.isEmpty(@keywords) && _.isNull(@location)

  clear: ->
    @query = ""
    @location = null

  toObject: ->
    query: @query
    location: @location?.name

  toString: ->
    "#{ @query }#{ if @location? then " | #{ @location.name }" else "" }"
