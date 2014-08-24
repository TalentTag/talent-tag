@talent.filter 'truncate', -> (text, length, options={}) ->
  if text and text.length > length
    truncated = text.substring 0, length
    truncated = truncated.substring(0, truncated.lastIndexOf(' ')) if options?.byWords
    truncated = truncated + "..." unless truncated[truncated.length-1] is '.'
    truncated
  else text


@talent.filter 'timeago', -> (date) ->
  moment(date).fromNow()

@talent.filter 'prettyPrint', -> (text) ->
  text = text.replace(/\n/g, '<br />')
  text.replace(/(\bhttps?:\/\/[-A-Z0-9А-Я+&@#\/%?=~_|!:,.;]*[-A-Z0-9А-Я+&@#\/%=~_|])/ig, '<a href="$1" target="_blank">$1</a>')
