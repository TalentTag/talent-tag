class UpdatesMailer < ActionMailer::Base

  default from: NOTIFICATIONS_EMAIL, template_path: 'mail/updates'

  def new_entries email, updates
    @updates = updates
    mail to: email, subject: "Новые записи в ваших виртуальных папках"
  end

end
