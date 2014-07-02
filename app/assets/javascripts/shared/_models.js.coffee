@talent.factory 'Message', ["$resource", "talentData", ($resource, talentData) ->

  Message = $resource "/account/messages/:id", { id: "@id" }

  Message::sender = ->
    switch @user_id
      when talentData.user.id then talentData.user
      when talentData.currentUser.id then talentData.currentUser

  Message

]
