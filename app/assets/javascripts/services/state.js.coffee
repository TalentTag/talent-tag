@talent.service 'State', ->

  keywords: []
  location: null

  isEmpty: ->
    _.isEmpty(@keywords) && _.isNull(@location)

  addKeyword: (keyword) ->
    unless keyword in @keywords
      @keywords.push(keyword)
      @changeCallback?.call()

  removeKeyword: (keyword) ->
    if keyword in @keywords
      @keywords = _.without @keywords, keyword
      @changeCallback?.call()

  setLocation: (location) ->
    unless @location is location
      @location = location
      @changeCallback?.call()

  unsetLocation: ->
    if @location?
      @location = null
      @changeCallback?.call()

  clear: ->
    unless @isEmpty()
      @keywords = []
      @location = null
      @changeCallback?.call()

  toObject: ->
    keywords: @keywords
    location: @location

  onChange: (callback) ->
    @changeCallback = callback
