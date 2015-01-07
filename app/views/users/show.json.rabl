object @user

attributes :id, :firstname, :lastname, :name, :avatar, :status, :profile, :tags, :type

node(:company) do |user|
  { name: user.company.name, id: user.company.id } rescue nil
end

node(:follows) do |user|
  user.follows.pluck(:id) rescue nil
end
