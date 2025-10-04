class Api::V1::SubscriptionsController < ApplicationController
  include Paginatable
  include Filterable

  before_action :set_customer, only: [ :index, :create ]
  before_action :set_subscription, only: [ :show, :update, :destroy, :cancel ]



  # GET /api/v1/customers/:customer_id/subscriptions
  def index
    @subscriptions = @customer.subscriptions
                    .then { |scope| apply_filters(scope, params) }
                    .then { |scope| apply_search(scope, params[:search]) }
                    .then { |scope| apply_sorting(scope, sort_by: params[:sort_by], sort_order: params[:sort_order]) }
                    .page(current_page)
                    .per(per_page)


    render json: {
      subscriptions: SubscriptionSerializer.new(@subscriptions).serializable_hash,
      meta: pagination_meta(@subscriptions)
    }
  end

  def show
    render json: {
      subscription: SubscriptionSerializer.new(@subscription).serializable_hash
    }
  end

  def create
    service = SubscriptionService.new
    data = subscription_params_with_customer.to_h.symbolize_keys
    subscription = service.create_subscription(**data)


    render json: SubscriptionSerializer.new(subscription).serializable_hash
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  def update
    raise NotImplementedError, "Update de assinatura não implementado"
  end

  def destroy
    raise NotImplementedError, "Destroy de assinatura não implementado"
  end

  def cancel
    service = SubscriptionService.new
    subscription = service.cancel_subscription(
      @subscription.id,
      cancel_pending_invoices: params.fetch(:cancel_pending_invoices, true))

    render json: SubscriptionSerializer.new(subscription).serializable_hash
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Assinatura não encontrada" }, status: :not_found
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def subscription_params
    params.require(:subscription).permit(
      :customer_id,
      :product_code,
      :plan_id,
      :payment_method,
      :gateway_type # Ex: :pagarme, :asaas
      )
  end


  # 🔑 Aqui mergeamos o customer_id automaticamente
  def subscription_params_with_customer
    subscription_params.merge(customer_id: @customer.id)
  end
end
