@talent.filter 'date', -> (date, format) ->
  moment(date).format(format)
