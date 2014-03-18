@talent.filter 'truncate', -> (text, length, byWords) ->
  if text and text.length > length
    truncated = text.substring 0, length
    truncated = truncated.substring(0, truncated.lastIndexOf(' ')) if byWords
    truncated = truncated + "..." unless truncated[truncated.length-1] is '.'
    truncated
  else text
