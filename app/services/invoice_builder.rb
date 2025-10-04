# app/services/invoice_builder.rb
# Múltiplos Produtos numa Mesma Fatura
class InvoiceBuilder
  def initialize(customer)
    @customer = customer
    @items = []
  end

  def add_product(product, quantity = 1, description = nil)
    @items << {
      product: product,
      quantity: quantity,
      description: description || product.name,
      price: product.price
    }
  end

  def build(billing_type = :one_time, due_date = nil)
    invoice = Invoice.new(
      customer: @customer,
      billing_type: billing_type,
      due_date: due_date || default_due_date(billing_type),
      amount: calculate_total
    )

    @items.each do |item|
      invoice.invoice_items.build(
        product: item[:product],
        quantity: item[:quantity],
        description: item[:description],
        price: item[:price]
      )
    end

    invoice
  end

  private

  def calculate_total
    @items.sum { |item| item[:price] * item[:quantity] }
  end

  def default_due_date(billing_type)
    case billing_type
    when :one_time then 7.days.from_now
    when :recurring then 1.month.from_now
    else Time.current
    end
  end
end

# Uso:
builder = InvoiceBuilder.new(customer)
builder.add_product(pms_product, 1)
builder.add_product(channel_product, 2)
invoice = builder.build(:one_time)
invoice.save!
