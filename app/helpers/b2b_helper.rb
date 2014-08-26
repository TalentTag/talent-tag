module B2bHelper

  def notifications
    @notifications ||= begin
      ids = current_user.follows.map { |f| f.following.id }
      Notification.where ids
    end
  end


  def paylink_for payment
    params = {
      pg_amount: payment.plan.price,
      pg_description: "Премиум-аккаунт: #{ payment.plan.name }",
      pg_failure_url: fail_payments_url,
      pg_language: 'ru',
      pg_merchant_id: 6246,
      pg_order_id: payment.identifier,
      pg_salt: Digest::MD5.hexdigest("TT-#{ Time.now }"),
      pg_success_url: complete_payments_url
    }
    hash = "payment.php;#{ params.values.join(';') };pudyxihigyvojuqy"
    signature = Digest::MD5.hexdigest hash
    url = "https://www.platron.ru/payment.php?#{ URI.encode_www_form params.merge(pg_sig: signature) }"

    link_to "Оплатить", url, confirm: "Подтвердить платеж?"
  end

end
