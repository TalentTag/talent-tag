@talent.filter 'prettyPrint', -> (text) ->
  text = text.replace(/\n/g, '<br />')
  text.replace(/(\bhttps?:\/\/[-A-Z0-9А-Я+&@#\/%?=~_|!:,.;]*[-A-Z0-9А-Я+&@#\/%=~_|])/ig, '<a href="$1" target="_blank">$1</a>')
