class AuthMailer < ActionMailer::Base

  default from: NOTIFICATIONS_EMAIL, template_path: 'mail/auth'

  def signup_employer user
    mail to: user.email, subject: "Регистрация на talent-tag.ru"
  end

  def signup_specialist user
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

  def invite invite
    @invite = invite
    mail to: invite.email, subject: "Приглашение на talent-tag.ru"
  end

  # def add_company user
  #   @user = user
  #   mail to: user.email, subject: "Регистрация компании на talent-tag.ru"
  # end

end
