class Notification::Specialists < Notification

  belongs_to :author, class_name: "Specialist"

end
