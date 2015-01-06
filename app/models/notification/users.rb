class Notification::Users < Notification

  belongs_to :author, class_name: "User"

end
