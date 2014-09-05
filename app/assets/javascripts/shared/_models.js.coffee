@talent.factory 'Entry', ["$resource", ($resource) ->

  Entry = $resource "/entries/:id.json", { id: "@id" }, { update: { method: "PUT" } }

  Entry::hasProfile = -> @author and @author.profile? and not _.isEmpty @author.profile

  Entry

]



@talent.factory 'Message', ["$resource", "talentData", ($resource, talentData) ->

  Message = $resource "/account/messages/:id", { id: "@id" }

  Message::conversation = ->
    _.findWhere talentData.conversations, id: @conversation_id

  Message::sender = ->
    if @user_id is talentData.currentUser.id
      talentData.currentUser
    else
      @conversation().recipient

  Message

]
