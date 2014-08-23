@talent.factory 'Entry', ["$resource", ($resource) ->

  Entry = $resource "/entries/:id.json", { id: "@id" }, { update: { method: "PUT" } }

  Entry::hasProfile = -> @author and @author.profile? and not _.isEmpty @author.profile

  Entry

]



@talent.factory 'Message', ["$resource", "talentData", ($resource, talentData) ->

  Message = $resource "/account/messages/:id", { id: "@id" }

  Message::sender = ->
    switch @user_id
      when talentData.user.id then talentData.user
      when talentData.currentUser.id then talentData.currentUser

  Message

]
