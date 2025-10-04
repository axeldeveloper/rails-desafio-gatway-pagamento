# app/models/customer.rb
class Customer < ApplicationRecord
  # enum :status, { active: 0, inactive: 1, suspended: 2 }, default: :active
  enum :status, {
    active: "active",
    inactive: "inactive",
    suspended: "suspended"
   }, default: "active"

  # Associations
  has_many :billing_profiles, dependent: :destroy
  has_many :subscriptions, through: :billing_profiles
  has_many :invoices, through: :billing_profiles
  has_many :payments, through: :billing_profiles
  has_many :payment_methods, dependent: :destroy

  accepts_nested_attributes_for :payment_methods, allow_destroy: true

  after_commit :enqueue_gateway_sync, on: :create, unless: :skip_gateway_sync?



  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :document, presence: true, uniqueness: true,
                      length: { minimum: 11, maximum: 14 }

  validates :phone, format: { with: /\A[\d\s\-\(\)\+]+\z/ }, allow_blank: true

  validates :zip_code, format: { with: /\A\d{5}-?\d{3}\z/ }, allow_blank: true

  validates :country, presence: true, length: { is: 2 }

  store_accessor :external_ids, :pagarme_id, :asaas_id

  # Callbacks
  before_validation :normalize_attributes
  before_save :format_document

  # Scopes
  scope :search, ->(term) { where("name ILIKE ? OR email ILIKE ?", "%#{term}%", "%#{term}%") }
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }


  def set_external_id(provider, value)
    self.external_ids = (external_ids || {}).merge(provider.to_s => value)
  end


  private def normalize_attributes
    self.email = email&.downcase&.strip
    self.name = name&.titleize&.strip
    self.country = country&.upcase
  end

  def format_document
    # Remove caracteres especiais do documento
    self.document = document&.gsub(/\D/, "")
  end

  # Método para verificar se é CPF ou CNPJ
  def document_type
    return "cpf" if document.length == 11
    return "cnpj" if document.length == 14
    "unknown"
  end

  # Método para formatar documento
  def formatted_document
    case document_type
    when "cpf"
      document.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
    when "cnpj"
      document.gsub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '\1.\2.\3/\4-\5')
    else
      document
    end
  end


  private def enqueue_gateway_sync
    CustomerGatewaySyncJob.perform_async(self.id)
  end

  def skip_gateway_sync?
    Rails.env.test? || Rails.env.development? && defined?(Rails::DB_SEED)
  end
end
