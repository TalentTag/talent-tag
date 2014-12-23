object @user

attributes :id, :firstname, :lastname, :name, :avatar, :status, :profile, :tags

node(:company) do |user|
  { name: user.company.try(:name), id: user.company.try(:id) }
end if @user && @user.type == :employer

node(:follows) do |user|
  user.follows.pluck :id
end if @user && @user.type == :employer #|| @owns_account
