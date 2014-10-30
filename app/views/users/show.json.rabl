object @user

attributes :id, :firstname, :lastname, :name, :avatar, :status, :profile, :tags

node(:company) do |user|
  { name: user.company.try(:name), id: user.company.try(:id) }
end if signed_in?

node(:follows) do |user|
  user.follows.pluck :following_id
end if signed_in? && @user == current_user
