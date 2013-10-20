class ProposalMailer < ActionMailer::Base

  default from: NOTIFICATIONS_EMAIL, template_path: 'mail/proposal'

  def awaiting proposal
    @company = proposal.company
    mail to: SUPPORT_EMAIL, subject: "Заявка на подтверждение аккаунта"
  end

  def accepted proposal
    mail to: proposal.company.owner.email, subject: "Подтверждение аккаунта talent-tag.ru"
  end

  def rejected proposal
    @proposal = proposal
    mail to: proposal.company.owner.email, subject: "Подтверждение аккаунта talent-tag.ru"
  end

end
