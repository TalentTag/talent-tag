object @user

attributes :id, :firstname, :lastname, :name, :avatar, :status, :profile, :tags

node(:company) do |user|
  { name: user.company.try(:name), id: user.company.try(:id) }
end if is_employer?

node(:follows) do |user|
  user.follows.pluck :following_id
end if is_employer? && @owns_account
