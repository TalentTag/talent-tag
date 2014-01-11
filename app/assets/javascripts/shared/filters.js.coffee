@talent.filter 'truncate', -> (text, length, byWords) ->
  if text.length < length
    text
  else
    truncated = text.substring 0, length
    truncated = truncated.substring(0, truncated.lastIndexOf(' ')) if byWords
    truncated = truncated + "..." unless truncated[truncated.length-1] is '.'
    truncated
