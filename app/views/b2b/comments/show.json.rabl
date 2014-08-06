object @comment
attributes :id, :text, :created_at, :entry_id
node :author do |comment|
  {
    name: comment.user.name,
    avatar: comment.user.avatar
  }
end
