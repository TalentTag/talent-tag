@talent.filter 'timeago', -> (date) ->
  moment(date).fromNow()
