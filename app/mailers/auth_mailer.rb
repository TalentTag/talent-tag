class AuthMailer < ActionMailer::Base

  default from: NOTIFICATIONS_EMAIL, template_path: 'mail/auth'

  def signup user
    mail to: user.email, subject: "Регистрация на talent-tag.ru"
  end

  def forgot user
    @user = user
    mail to: user.email, subject: "Восстановление пароля на talent-tag.ru"
  end

  def credentials user
    @user = user
    mail to: user.email, subject: "Изменение данных на talent-tag.ru"    
  end

end
