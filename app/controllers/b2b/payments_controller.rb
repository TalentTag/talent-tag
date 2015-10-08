class B2b::PaymentsController < B2b::BaseController

  respond_to :json

  before_action :find_payment, only: %i(complete fail)
  before_action :check_gateway_signature, only: :complete
  skip_before_filter :verify_authenticity_token, only: %i(complete fail)


  def index
    @payments = current_account.payments.limit(30)
  end


  def create
    authorize! :update_to_premium, current_account
    plan = Plan.find(params[:rate] || 1)
    payment = Payment.create!(plan_id: plan.id, company_id: current_account.id)
    render nothing: true, status: :created
  end


  def init
    payment = Payment.find_by!(id: params[:id])
    authorize! :update, payment

    params = {
      pg_amount: payment.plan.price,
      pg_description: "Премиум-аккаунт: #{ payment.plan.name }",
      pg_failure_url: payment_fail_url(payment_id: payment.identifier),
      pg_language: 'ru',
      pg_merchant_id: 8264,
      pg_order_id: payment.identifier,
      pg_salt: Digest::MD5.hexdigest("TT-#{ Time.now }"),
      pg_site_url: payments_url,
      pg_success_url: payment_complete_url(payment_id: payment.identifier)
    }
    hash = "payment.php;#{ params.values.join(';') };qokuqoviwujoqezy"
    signature = Digest::MD5.hexdigest hash

    redirect_to "https://www.platron.ru/payment.php?#{ URI.encode_www_form params.merge(pg_sig: signature) }"
  end


  def complete
    authorize! :update, @payment
    @payment.started_processing
    @payment.complete!
    redirect_to payments_url, flash: { notice: "Платеж проведен" }
  end


  def fail
    authorize! :update, @payment
    @payment.fail!
    redirect_to payments_url, flash: { notice: "Платеж отменен" }
  end


  private

  def find_payment
    @payment = Payment.find_by!(identifier: params[:pg_order_id])
  end

  def check_gateway_signature
    pg_sig = params.delete :pg_sig
    sorted_params = params.select { |key, value| key.to_s.match(/\Apg_/) }.sort.map { |e| e[1] }
    signature = Digest::MD5.hexdigest("complete;#{ sorted_params.join(';') };qokuqoviwujoqezy")
    raise "Invalid signature" unless signature==pg_sig
  end

end
