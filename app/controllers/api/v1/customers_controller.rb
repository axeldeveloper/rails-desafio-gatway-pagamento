class Api::V1::CustomersController < ApplicationController
  include Paginatable
  include Filterable

  before_action :set_customer, only: [ :show, :update, :destroy ]


  # GET /api/v1/customers
  def index
     @customers = Customer.includes(:billing_profiles)
                  .then { |scope| apply_filters(scope, params) }
                  .then { |scope| apply_search(scope, params[:search]) }
                  .then { |scope| apply_sorting(scope, sort_by: params[:sort_by], sort_order: params[:sort_order]) }
                  .page(current_page)
                  .per(per_page)
    render json: {
      customers: customers_json(@customers),
      meta: pagination_meta(@customers)
    }
  end

  # GET /api/v1/customers/:id
  def show
    render json: {
      customer: customer_json(@customer, include_relations: true)
    }
  end

  # POST /api/v1/customers
  def create
      customer = Customer.find_or_initialize_by(document: customer_params[:document])
      customer.assign_attributes(customer_params)
      customer.save!

      render json: {
        customer: customer_json(customer),
        message: "Cliente criado com sucesso"
      }, status: :created


  rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end


  # PUT/PATCH /api/v1/customers/:id
  def update
    if @customer.update(customer_params)
      render json: {
        customer: customer_json(@customer),
        message: "Cliente atualizado com sucesso"
      }
    else
      render json: {
        errors: @customer.errors.full_messages,
        details: @customer.errors.messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/customers/:id
  def destroy
    if @customer.billing_profiles.exists?
      render json: {
        error: "Não é possível excluir cliente com perfis de cobrança ativos",
        message: "Cliente possui assinaturas ou faturas associadas"
      }, status: :unprocessable_entity
    elsif @customer.destroy
      render json: {
        message: "Cliente excluído com sucesso"
      }
    else
      render json: {
        errors: @customer.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Cliente não encontrado",
      message: "Cliente com ID #{params[:id]} não existe"
    }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(
      :name, :email, :document, :phone,
      :address, :city, :state, :zip_code, :country, :status,
      external_ids: {},
      payment_methods_attributes: [ :id, :kind, :default, :_destroy, { external_ids: {} } ]
    )
  end

  # def apply_filters(scope)
  #   scope = scope.by_status(params[:status]) if params[:status].present?
  #   scope = scope.where(country: params[:country]) if params[:country].present?
  #   scope = scope.where("created_at >= ?", Date.parse(params[:created_after])) if params[:created_after].present?
  #   scope = scope.where("created_at <= ?", Date.parse(params[:created_before])) if params[:created_before].present?
  #   scope
  # rescue ArgumentError => e
  #   scope # Ignora filtros de data inválidos
  # end

  # def apply_search(scope)
  #   return scope unless params[:search].present?
  #   scope.search(params[:search])
  # end

  # def apply_sorting(scope)
  #   sort_by = params[:sort_by] || "created_at"
  #   sort_order = params[:sort_order] || "desc"

  #   allowed_sorts = %w[name email created_at updated_at status]
  #   sort_by = "created_at" unless allowed_sorts.include?(sort_by)
  #   sort_order = "desc" unless %w[asc desc].include?(sort_order)

  #   scope.order("#{sort_by} #{sort_order}")
  # end

  # def current_page
  #   [ params[:page].to_i, 1 ].max
  # end

  # def per_page
  #   per_page = params[:per_page].to_i
  #   per_page = 25 if per_page <= 0 || per_page > 100
  #   per_page
  # end

  # def pagination_meta(collection)
  #   {
  #     current_page: collection.current_page,
  #     total_pages: collection.total_pages,
  #     total_count: collection.total_count,
  #     per_page: collection.limit_value,
  #     has_next: collection.current_page < collection.total_pages,
  #     has_prev: collection.current_page > 1
  #   }
  # end

  def customers_json(customers)
    customers.map { |customer| customer_json(customer) }
  end

  def customer_json(customer, include_relations: false)
    result = {
      id: customer.id,
      external_ids: customer.external_ids,
      name: customer.name,
      email: customer.email,
      document: customer.formatted_document,
      document_type: customer.document_type,
      phone: customer.phone,
      address: customer.address,
      city: customer.city,
      state: customer.state,
      zip_code: customer.zip_code,
      country: customer.country,
      status: customer.status,
      payment_methods: customer.payment_methods.map { |pm| { id: pm.id, kind: pm.kind, external_ids: pm.external_ids, default: pm.default } },
      created_at: customer.created_at.iso8601,
      updated_at: customer.updated_at.iso8601
    }

    if include_relations
      result[:billing_profiles_count] = customer.billing_profiles.count
      result[:active_subscriptions_count] = customer.subscriptions.active.count
      result[:total_invoices_count] = customer.invoices.count
    end

    result
  end
end
