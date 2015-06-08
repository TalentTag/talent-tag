@talent.controller "talent.DetailsCtrl", ["$scope", "$routeParams", "State", "Entry", "Comment", ($scope, $routeParams, State, Entry, Comment) ->

  $scope.entry = Entry.get id: $routeParams.id, (entry) ->
    entry.comments = (new Comment(attrs) for attrs in entry.comments)
    $scope.entry = entry
  $scope.$parent.lastEntry = $scope.entry


  $scope.removeEntryFromFolder = (folder, entry) ->
    if confirm "Снять метку #{ folder.name } с записи?"
      folder.entries = _.reject(folder.entries, (e) -> entry.id is e)
      $scope.entries = _.reject($scope.entries, (e) -> entry is e) if folder is $scope.folder
      folder.removeEntry entry

  $scope.blacklist = (entry) ->
    if $scope.search and confirm("Убрать запись из виртуальной папки?")
      $scope.search.blacklist entry
      $scope.entries = _.reject $scope.entries, (e) -> e is entry

  $scope.postComment = ->
    if $scope.newComment
      comment = new Comment
        text: $scope.newComment
        entry_id: $scope.entry.id
      comment.$save()
      $scope.entry.comments.push comment
      $scope.newComment = null

  $scope.deleteComment = (comment) ->
    if confirm("Удалить комментарий?")
      comment.$delete()
      $scope.entry.comments = _.without $scope.entry.comments, comment


  State.onChange ->
    window.history.pushState null, null, '/'

  $scope.backOrIndex = ->
    window.history.back() || window.history.pushState(null, null, '/')

]
