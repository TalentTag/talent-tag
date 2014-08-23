object @entry
attributes :id, :body, :source_id, :created_at, :fetched_at, :author, :user_id, :duplicate_of, :duplicates
attribute :url if can?(:read, :premium_data)
node :comments do |entry|
  entry.comments.where(company_id: current_account.id).map do |comment|
    partial "/b2b/comments/show", object: comment
  end
end
