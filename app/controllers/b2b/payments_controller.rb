class B2b::PaymentsController < B2b::BaseController

  respond_to :json

  before_action :all_payments, only: %i(index complete fail)
  before_action :find_payment, only: %i(complete fail)


  def create
    authorize! :update_to_premium, current_account
    plan = Plan.find(params[:rate] || 1)
    payment = Payment.create!(plan_id: plan.id, company_id: current_account.id)
    render nothing: true, status: :created
  end


  def complete
    authorize! :update, @payment
    @payment.started_processing!
    if credit_card.validate.empty?
      response = TalentTag::Application::GATEWAY.purchase(@payment.plan.price, credit_card)
      if response.success?
        @payment.complete!
        flash[:notice] = "Платеж проведен"
      else
        flash[:error] = "Ошибка при проведении транзакции"
      end
      render :index
    end
  end


  def fail
    authorize! :update, @payment
    @payment.fail!
    flash[:notice] = "Платеж отменен"
    render :index
  end


  private

  def all_payments
    @payments = current_account.payments
  end

  def find_payment
    @payment = Payment.find_by!(id: params[:id])
  end


  def credit_card # TODO temp
    ActiveMerchant::Billing::CreditCard.new\
      :first_name         => 'John',
      :last_name          => 'Doe',
      :number             => '4242000000000000',
      :month              => Time.now.month,
      :year               => Time.now.year+1,
      :verification_value => '123'
  end

end
