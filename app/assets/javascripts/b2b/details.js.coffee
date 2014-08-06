@talent.controller "talent.DetailsCtrl", ["$scope", "$routeParams", "talentData", "Entry", "Comment", ($scope, $routeParams, talentData, Entry, Comment) ->

  $scope.entry = Entry.get id: $routeParams.id, (entry) -> $scope.entry = entry
  $scope.$parent.lastEntry = $scope.entry

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
]
