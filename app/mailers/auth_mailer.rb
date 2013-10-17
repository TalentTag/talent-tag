class AuthMailer < ActionMailer::Base

  default from: NOTIFICATIONS_EMAIL, template_path: 'mail/auth'

  def signup user
    mail to: user.email, subject: "Регистрация на talent-tag.ru"
  end

end
