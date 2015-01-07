@talent.factory 'Message', ["$resource", "talentData", ($resource, talentData) ->

  Message = $resource "/account/messages/:id", { id: "@id" }

  Message::conversation = ->
    _.findWhere talentData.conversations, id: @conversation_id

  Message

]
