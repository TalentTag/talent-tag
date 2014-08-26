class B2b::PaymentsController < B2b::BaseController

  respond_to :json

  before_action :find_payment, only: %i(complete fail)
  before_action :check_gateway_signature, only: :complete
  skip_before_filter :verify_authenticity_token, only: %i(complete fail)


  def index
    @payments = current_account.payments
  end


  def create
    authorize! :update_to_premium, current_account
    plan = Plan.find(params[:rate] || 1)
    payment = Payment.create!(plan_id: plan.id, company_id: current_account.id)
    render nothing: true, status: :created
  end


  def complete
    authorize! :update, @payment
    @payment.started_processing
    @payment.complete!
    flash[:notice] = "Платеж проведен"
    redirect_to payments_url
  end


  def fail
    authorize! :update, @payment
    @payment.fail!
    flash[:notice] = "Платеж отменен"
    redirect_to payments_url
  end


  private

  def find_payment
    @payment = Payment.find_by!(identifier: params[:pg_order_id])
  end

  def check_gateway_signature
    pg_sig = params.delete :pg_sig
    sorted_params = params.select { |key, value| key.to_s.match(/\Apg_/) }.sort.map { |e| e[1] }
    signature = Digest::MD5.hexdigest("complete;#{ sorted_params.join(';') };pudyxihigyvojuqy")
    raise "Invalid signature" unless signature==pg_sig
  end

end
