@talent.service 'State', ->

  location: (location=null) =>
    if _.isNull(location)
      @location
    else
      @location = location
