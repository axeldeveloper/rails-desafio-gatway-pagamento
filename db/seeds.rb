

puts "🌱 Iniciando seeds..."
Rails::DB_SEED = true

emails = 'admin@example.com'
# Limpar dados existentes (apenas em desenvolvimento)
if Rails.env.development?
  puts "🧹 Limpando dados existentes..."
  puts "🔄 Limpando tabela billing_profiles..."
  BillingProfile.destroy_all

  puts "🔄 Limpando tabela subscription..."
  Subscription.destroy_all if defined?(Subscription)

  puts "🔄 Limpando tabela planos..."
  Plan.destroy_all if defined?(Plan)

  puts "🔄 Limpando tabela produtos..."
  Product.destroy_all if defined?(Product)

  puts "🔄 Limpando tabela customers..."
  Customer.destroy_all

  puts "🔄 Limpando tabela Users..."
  User.delete_all

  puts "✅ Dados limpos"
end


#
# ---- User ----
User.create(email: emails, password: 'pas123')
puts "✅ User criado/atualizado: #{emails}"
puts "✅ User criados com sucesso!"

# ---- Products ----

puts "📦 Criando produtos..."
products = [
  {
    name: "PMS Pro",
    code: "pms_pro",
    description: "Sistema de gestão hoteleira profissional",
    status: :active
  },
  {
    name: "Channel Manager",
    code: "channel_manager",
    description: "Gerenciador de canais de distribuição",
    status: :active
  },
  {
    name: "Motor de Reservas",
    code: "motor_reservas",
    description: "Sistema de reservas online",
    status: :active
  }
]
products.each do |attrs|
  product = Product.find_or_initialize_by(code: attrs[:code])
  product.update!(attrs)
  puts "✅ Produto criado/atualizado: #{product.name}"
end
puts "✅ Produtos criados: #{Product.count}"
puts "✅ Produtos criados com sucesso!"


# ---- Plans ----
# # Criar planos
puts "💰 Criando planos..."
puts "🔄 Criando/atualizando planos..."
plans = [

  { name: 'PMS Pro Mensal', billing_type: "prepaid", interval: :month, minimum_price_cents: 10000, product: Product.find_by(code: "pms_pro")  },
  { name: 'PMS Pro Anual', billing_type: "prepaid", interval: :year, minimum_price_cents: 10000, product: Product.find_by(code: "channel_manager")  },
  { name: 'Channel Manager Básico', billing_type: "prepaid", interval: :month, minimum_price_cents: 10000, product: Product.find_by(code: "channel_manager")  },
  { name: 'Motor Reservas Premium', billing_type: "prepaid", interval: :day, minimum_price_cents: 10000, product: Product.find_by(code: "pms_pro")  },
  {
    name: "Mensalidade",
    interval: "month",
    billing_type: "prepaid",
    status: "active",
    minimum_price_cents: 10000,
    product: Product.find_by(code: "motor_reservas")
  },
  {
    name: "Anualidade",
    interval: "year",
    billing_type: "prepaid",
    status: "active",
    minimum_price_cents: 100000,
    product: Product.find_by(code: "motor_reservas")
  }
]
plans.each do |attrs|
  plan = Plan.find_or_initialize_by(name: attrs[:name])
  plan.payment_methods = [ 'credit_card', 'boleto' ]
  plan.update!(attrs)
  puts "✅ Plano criado/atualizado: #{plan.name}"
  puts "✅ Plano criados com sucesso!"
end
puts "✅ Planos criados: #{Product.count}"
puts "✅ Planos criados com sucesso!"


# ---- Customers ----
puts "👥 Criando customers..."
puts "🔄 Criando/atualizando customers..."
customers_data = [
  # Customers ASAAS (10)
  { name: 'Hotel Copacabana Palace', email: 'contato@copacabanapalace.com',  document: '12345678000195', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_001" } },
  { name: 'Pousada Maravilha',       email: 'reservas@pousadamaravilha.com', document: '98765432000198', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_002" } },
  { name: 'Resort Vista Mar',        email: 'admin@resortvistamar.com',      document: '11223344000155', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_003" } },
  { name: 'Hotel Boutique Centro',   email: 'contato@boutiquecentro.com',    document: '55667788000199', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_004" } },
  { name: 'Pousada Tropical',        email: 'info@pousadatropical.com',      document: '99887766000133', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_005" } },
  { name: 'Hotel Business Tower',    email: 'comercial@businesstower.com',   document: '77889900000177', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_006" } },
  { name: 'Resort Águas Claras',     email: 'reservas@aguasclaras.com',      document: '44556677000122', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_007" } },
  { name: 'Hotel Fazenda Boa Vista', email: 'contato@fazendaboavista.com',   document: '33445566000144', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_008" } },
  { name: 'Pousada Recanto do Mar',  email: 'info@recantodomar.com',         document: '22334455000166', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_009" } },
  { name: 'Hotel Urbano Premium',    email: 'admin@urbanopremium.com',       document: '66778899000188', gateway: 'asaas', external_ids: { asaas_id: "cust_asaas_0010" } },

  # Customers Pagar.me (10)
  { name: 'João Silva',     email: 'joao.silva@email.com',     document: '12345678901', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_001" } },
  { name: 'Maria Santos',   email: 'maria.santos@email.com',   document: '98765432100', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_002" } },
  { name: 'Pedro Costa',    email: 'pedro.costa@email.com',    document: '11322233344', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_003" } },
  { name: 'Ana Oliveira',   email: 'ana.oliveira@email.com',   document: '55566677788', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_004" } },
  { name: 'Carlos Pereira', email: 'carlos.pereira@email.com', document: '99988877766', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_005" } },
  { name: 'Lucia Ferreira', email: 'lucia.ferreira@email.com', document: '77788899900', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_006" } },
  { name: 'Roberto Lima',   email: 'roberto.lima@email.com',   document: '44455566677', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_007" } },
  { name: 'Patricia Alves', email: 'patricia.alves@email.com', document: '33344455566', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_008" } },
  { name: 'Fernando Souza', email: 'fernando.souza@email.com', document: '22233344455', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_009" } },
  { name: 'Gabriela Rocha', email: 'gabriela.rocha@email.com', document: '66677788899', gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_0010" } },


  # Customers adicionais
  { name: "Empresa XPTO Ltda",  email: "contato@xpto.com.br", document: "12345678000199", gateway: 'pagarme', external_ids: { pagarme_id: "cust_pagarme_0013" } }
]
puts "🌱 Criando customers..."
Rails::DB_SEED = true
customers_data.each_with_index do |customer_data, index|
  customer = Customer.find_or_create_by!(email: customer_data[:email]) do |c|
    c.name = customer_data[:name]
    c.document = customer_data[:document]
    c.phone = "+5511#{rand(100000000..999999999)}"
    c.external_ids = customer_data[:external_ids] || {}
    c.address = "Rua #{[ 'das Flores', 'do Comércio', 'Principal', 'da Liberdade' ].sample}, #{rand(1..999)}"
    c.city = [ 'São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Salvador', 'Fortaleza' ].sample
    c.state = [ 'SP', 'RJ', 'MG', 'BA', 'CE' ].sample
    c.zip_code = "#{rand(10000..99999)}-#{rand(100..999)}"
    c.status = :active
  end
  puts "✅ Customer criado/atualizado: #{customer.name}"
  puts "✅ Customer criados com sucesso!"


  # Criar billing profiles para cada produto
  codes = [ "pms_pro", "channel_manager", "motor_reservas" ]
  code  = codes.sample # escolhe 1 aleatório
  gateway_type = customer_data[:gateway]
  product = Product.find_by(code: code)
  if product.nil?
    Rails.logger.warn "⚠️ Produto não encontrado: #{code}"
    next
  end

  profile = BillingProfile.find_or_initialize_by(customer: customer, product: product)
  profile.gateway_type = gateway_type

  # # Gerar IDs específicos por gateway apenas se não existir
  profile.gateway_customer_id ||= if gateway_type == "asaas"
                                  "asaas_cust_#{SecureRandom.hex(8)}"
  else
                                  "cust_#{SecureRandom.hex(10)}"
  end

  profile.save!

  puts "✅ Customers criados: #{customer.id}, BillingProfile: #{profile.id}"
end

puts "✅ Customers criados: #{Customer.count}"
puts "✅ BillingProfiles criados: #{BillingProfile.count}"

# Estatísticas
asaas_profiles = BillingProfile.where(gateway_type: 'asaas').count
pagarme_profiles = BillingProfile.where(gateway_type: 'pagarme').count

puts "📊 Estatísticas:"
puts "✅ - ASAAS Profiles: #{asaas_profiles}"
puts "✅ - Pagar.me Profiles: #{pagarme_profiles}"
puts "✅ - Total Profiles: #{BillingProfile.count}"
