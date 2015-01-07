collection @messages

attributes :id, :text, :created_at

node :user do |message|
  partial "/users/show", object: message.user
end
