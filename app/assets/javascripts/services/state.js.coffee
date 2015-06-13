@talent.service 'State', ->

  query: ''
  location: null
  callbacks: []

  isEmpty: ->
    _.isEmpty @query

  init: (options={}) ->
    @query = options.query if options.query?
    @location = options.location if options.location?
    cb.call() for cb in @callbacks unless options.silent

  clear: (options={}) ->
    @query = ""
    @location = null
    cb.call() for cb in @callbacks unless options.silent

  toString: ->
    "#{ @query }#{ if @location?.name then " | #{ @location.name }" else "" }"

  in: (set) ->
    _.find set, (item) =>
      item.query is @query and item.location?.name is @location.name

  onChange: (callback) ->
    @callbacks.push callback unless callback in @callbacks
