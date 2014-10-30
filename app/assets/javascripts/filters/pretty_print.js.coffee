@talent.filter 'prettyPrint', -> (text) ->
  text = text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
  text = text.replace(/\n/g, '<br />')
  text = text.replace(/(\bhttps?:\/\/[-A-Z0-9А-Я+&@#\/%?=~_|!:,.;]*[-A-Z0-9А-Я+&@#\/%=~_|])/ig, '<a href="$1" target="_blank">$1</a>')
