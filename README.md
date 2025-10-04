# 🏦 Digital billing_gateway_api API

<div align="center">
  <img src="https://img.shields.io/badge/ruby-on-rails?style=for-the-badge&logo=ruby&logoColor=red" alt="Ruby">

  <img src="https://img.shields.io/badge/rails-6DC33F?style=for-the-badge&logo=ruby&logoColor=red" alt="Ruby on Rails">

  <img src="https://img.shields.io/badge/Spring%20Security-JWT-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white" alt="Spring Security">

  <img src="https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL">

  <img src="https://img.shields.io/badge/JUnit-5-25A162?style=for-the-badge&logo=junit5&logoColor=white" alt="JUnit">

  <img src="https://img.shields.io/badge/Swagger-OpenAPI-85EA2D?style=for-the-badge&logo=swagger&logoColor=white" alt="Swagger">
</div>

<div align="center">
  <h3>🚀 API REST segura e completa para sistema de pagamento  digital</h3>
  <p>Sistema moderno com autenticação JWT, bacground jobs, transações seguras e histórico completo.</p>
</div>

---

## 📋 Sobre o Projeto

A **Billing Gateway API** é uma aplicação backend robusta que simula operações de pagamento "gateway" com foco em **segurança**, **performance** e **escalabilidade**. Desenvolvida com Rails 8 Sidkiq, implementa autenticação JWT, controle de permissões SERA IMPLEMENTADA NO FUTURO.

### ✨ Principais Características

- 🔐 **Autenticação JWT** com JWT
- 👥 **Sistema de Roles**  `implementação futura`
- 🏧 **Operações bancárias** completas (subscription, customer)
- 📊 **Histórico detalhado** de todas as transações
- 🧪 **Cobertura de testes** com Rspec
- 📖 **Documentação automática** com OpenAPI/Swagger
- 🎯 **Tratamento global** de exceções


---

## 🛠 Stack Tecnológica

### Core Framework
- **ruby 3+** - Linguagem principal
- **Rails 8.x** - Framework base


### Segurança
- **JWT (JSON Web Tokens)** - Autenticação
- **BCrypt** - Criptografia de senhas


### Banco de Dados
- **PostgreSQL ** - Banco principal
- **ActiveRecord** - como ORM ou data manipulation


### Testes & Qualidade
- **Rspec** - Framework de testes


### Documentação & APIs
- **OpenAPI 3** - Especificação da API
- **Swagger UI** - Interface de documentação


---

## 🔐 Sistema de Segurança

## Dicas Importante para uso


### Usuários Padrão
A aplicação inicializa com dois usuários pré-configurados:
```ruby

$ rails console

User.create(:email => "admin@admin.com", :password => "admin123")
User.create(:email => "user@user.com", :password => "user123")
```


| Email | Senha | Role | Permissões |
|-------|-------|------|------------|
| `admin@admin.com` | `admin123` | **ADMIN** | Todas as operações (CRUD completo) |
| `user@user.com` | `user123` | **USER** | Leitura e criação apenas |




### Endpoints Protegidos
```
GET    /customers/**      → Lista o Customer
POST   /customers         → Cria um customer local e integra ao pagarme
PUT    /customers/**      → Atualiza dados do customer local
DELETE /customers/**      → Deleta um customer e cancela no pagarme
```

---

## 🚀 Funcionalidades

### 👥 Gestão de Clientes
- ✅ Cadastro com validação de CPF
- ✅ Busca por CPF individual
- ✅ Listagem completa
- ✅ Atualização de dados
- ✅ Exclusão de clientes
### 🏧 Subscription papgarme e asaas
- ✅ Criação de contas


### 📊 Auditoria & Histórico de importação
- ✅ Histórico completo de transações


---

## 📥 Instalação & Configuração

### Pré-requisitos
- ☕ **ruby 3 +**
- 🐬 **PostgreSQL+**
- 📦 **Docker+**

### 1. Clone & Configure
```bash
$ git clone https://github.com/seu-usuario/seu-projeto-api.git
$ cd billing-gateway-api

# Configure as variáveis de ambiente
$ export POSTGRES_DB=billing_db_development
$ export POSTGRES_USER=postgres
$ export POSTGRES_PASSWORD=postgres
# DATABASE_URL=postgresql://postgres:postgres@db:5432/billing_db_development
$ export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/billing_db_development

# Redis Configuration
$ export REDIS_URL=redis://localhost:6379/0

$ export SIDEKIQ_REDIS_URL=redis://localhost:6379/0


# Rails Configuration
$ export RAILS_ENV=development
$ export RAILS_MASTER_KEY=$(cat config/master.key)

$ export PAGARME_API_KEY=your_key_here
$ export ASAAS_API_KEY=your_key_here
```

# Configuração das credenciais
```sh

# Definir editor temporariamente
$ export EDITOR="code --wait"

# Editar credentials\n
$ rails credentials:edit

# OU executar em uma linha
$ EDITOR="code --wait" rails credentials:edit
```


**Aplicação disponível em:** `http://localhost:3000`
**Documentação Swagger:** `http://localhost:3000/api-docs/index.html`

---

## 📡 Principais Endpoints

### 🔑 Autenticação
| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| `POST` | `/api/v1/auth/register` | Registrar novo usuário | Não |
| `POST` | `/api/v1/auth/login` | Login/obter token JWT | Não |
| `POST` | `/api/v1/auth/me` | obter usuario logado  | Não |

### 👥 Clientes
| Método | Endpoint | Descrição | Permissão |
|--------|----------|-----------|-----------|
| `GET` | `/clientes` | Listar clientes | `user:read` |
| `GET` | `/clientes/{cpf}` | Buscar por CPF | `user:read` |
| `POST` | `/clientes` | Cadastrar cliente | `user:write` |
| `PUT` | `/clientes/{cpf}` | Alterar dados | `admin:update` |
| `DELETE` | `/clientes/{cpf}` | Remover cliente | `admin:delete` |

### 🏧 Contas & Operações
| Método | Endpoint | Descrição | Permissão |
|--------|----------|-----------|-----------|
| `GET` | `/contas/clientes/{cpf}/contas` | Contas do cliente | `user:read` |
| `POST` | `/contas` | Criar conta | `user:write` |
| `PUT` | `/contas/{id}/deposito` | Depósito | `user:write` |
| `PUT` | `/contas/{id}/saque` | Saque | `user:write` |
| `PUT` | `/contas/transferencias` | Transferência | `user:write` |
| `GET` | `/contas/{id}/simulacao-rendimento` | Simular rendimento | `user:read` |
| `GET` | `/contas/{id}/historico` | Histórico | `user:read` |

---

## 🧪 Testes Unitários

### Cobertura Completa
- **Controllers** - Testes com MockMvc
- **Services** - Testes de lógica de negócio
- **Repositories** - Testes de persistência
- **Integration** - Testes end-to-end

### Tecnologias de Teste


### Executar Testes
```bash
# Todos os testes
bundle exec rspec

# Testes específicos
bundle exec rspec
```

---

## 💡 Exemplos de Uso

### 1. Autenticação
```bash
# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@admin.com",
    "senha": "admin123"
  }'

# Response: {"token": "eyJhbGciOiJIUzI1NiJ9..."}
```

### 2. Operações Bancárias
```bash
# Criar cliente (com token)
curl -X POST http://localhost:3000/api/v1/customer \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Wallace Silva",
    "cpf": "123.456.789-00"
  }'

# Criar conta corrente
curl -X POST http://localhost:8080/contas \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "clienteId": 1,
    "tipoConta": "CC"
  }'

# Realizar depósito
curl -X PUT http://localhost:8080/contas/1/deposito \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "valor": 1500.00,
    "contaId": 1
  }'
```

---

## 🏗 Arquitetura

### Estrutura do Projeto
```
biiling_gateway_api/
├── 📁 config/             # Configurações (Security, CORS, etc.)
├── 📁 app/controller/     # Controllers REST
├── 📁 db/                 # Seed and Data migrations
├── 📁 enums/              # Enumerações (Role, Permission, etc.)
├── 📁 app/exceptions/     # Exceções customizadas
├── 📁 app/job/            # worker e jobs
├── 📁 app/model/
│   ├── customer/          # Entidadess
│   └── Subscription/      #
└── 📁 app/services/       # Lógica de negócio
├── 📁 scripts/            # comandos cutomizado e teste .http
```

### Padrões Aplicados
- **DTO Pattern** - Transferência de dados
- **Repository Pattern** - Acesso a dados
- **Service Layer** - Lógica de negócio
- **Global Exception Handler** - Tratamento centralizado de erros
- **Builder Pattern** - Construção de objetos complexos

---

## 🔍 Validações & Tratamento de Erros

### Validações Automáticas
- **CPF** - Validação brasileira
- **Email** - Formato válido

### Respostas de Erro Padronizadas
```json
{
  "timestamp": "2024-09-17T16:30:45",
  "message": "Cliente não encontrado",
  "details": "uri=/clientes/123.456.789-00"
}
```

### Códigos HTTP
- `200` ✅ Sucesso
- `201` ✅ Criado
- `204` ✅ Sem conteúdo
- `400` ❌ Dados inválidos
- `401` ❌ Não autenticado
- `403` ❌ Sem permissão
- `404` ❌ Não encontrado
- `409` ❌ Conflito
- `422` ❌ Regra de negócio

---


# Criar projeto Rails API-only

```sh
$ rails new billing_gateway_api --api --database=postgresql --skip-test

# Navegar para o diretório
$ cd billing_gateway_api

# instalar dependencias
$ bundle install

```


# 📁 Gerando a Estrutura do Sistema

```sh
# Gerando Models
# User
$ rails generate model User email:string

# Customer
$ rails generate model Customer name:string email:string:uniq document:string:uniq phone:string created_at:datetime updated_at:datetime

# Product
$ rails generate model Product name:string code:string:uniq description:text status:integer created_at:datetime updated_at:datetime

# Plan
$ rails generate model Plan name:string amount_cents:integer billing_type:integer interval:integer product:references created_at:datetime updated_at:datetime

# BillingProfile
$ rails generate model BillingProfile customer:references product:references gateway_customer_id:string gateway_type:string migrated_at:datetime

# Subscription
$ rails generate model Subscription billing_profile:references plan:references gateway_subscription_id:string:uniq status:integer started_at:datetime ended_at:datetime

# Invoice
$ rails generate model Invoice subscription:references billing_profile:references amount_cents:integer due_date:date status:integer gateway_invoice_id:string

# InvoiceItem
$ rails generate model InvoiceItem invoice:references product:references description:string amount_cents:integer quantity:integer

# Payment
$ rails generate model Payment invoice:references billing_profile:references gateway_payment_id:string:uniq amount_cents:integer status:integer payment_method:integer processed_at:datetime

# MigrationLogs
$ rails generate model MigrationLog


# Gerando Controllers API

$ rails generate controller Api::V1::Authentication login me

$ rails generate controller Api::V1::Customers index show create update destroy --skip-routes

$ rails generate controller Api::V1::Products index show create update destroy --skip-routes

$ rails generate controller Api::V1::Plans index show create update destroy --skip-routes

$ rails generate controller Api::V1::Subscriptions index show create update destroy cancel reactivate --skip-routes

$ rails generate controller Api::V1::Invoices index show create charge cancel --skip-routes

$ rails generate controller Api::V1::Payments index show create --skip-routes

# Gerar controller de webhooks
$ rails generate controller Api::V1::Webhooks::Pagarme handle --skip-routes


```

# ✅ Swagger
## Gerando documentação do swagger
```sh
# 1. RSpec
$ rails generate rspec:install

# 2. API
$ rails generate rswag:api:install

# 3. UI
$ rails generate rswag:ui:install

# 4. Specs
$ rails generate rswag:specs:install
```



# ✅ Banco de Dados
## ignore esta ação se tiver usando docker

```sql
-- conectrtse ao banco para criar
CREATE DATABASE billing_db_development ;
```

# 📁 Execute a Aplicação local

```sh
# diretorio do projeto
$ cd billing-gateway-api

$ bundle install

# rodoar o compose par ao redis e o postgres
$ docker compose -f 'docker-compose.yml' up -d --build 'redis'

$ docker compose -f 'docker-compose.yml' up -d --build 'db'

$ rails db:prepare
# OR
$ rails db:create && rails db:migrate

# iniciar o servidor
$ rails s
#  visualizar em http://localhost:3000

```


# 📁 Execute a Aplicação usando docker

```sh
# Construir e iniciar todos os serviços
$ docker-compose up --build
# or
$ docker-compose build
$ docker-compose up

# Executar em background
$ docker compose up -d

# Executar comandos Rails via Docker
$ docker compose exec web rails db:create
$ docker compose exec web rails db:migrate
$ docker compose exec web rails db:seed

# caso queira fazer tudo via docker po partir deste exemplo
$ docker compose exec web rails AQUI_SEU_COMANDO

# Exemplo
$ docker compose exec web rails generate model Product name:string code:string:uniq description:text status:integer created_at:datetime updated_at:datetime

$ docker compose exec web rails generate controller ...

# Parar serviços
$ docker compose down

# Ver logs
$ docker compose logs web
$ docker compose logs sidekiq

# swagger
$ docker compose exec web bundle exec rails generate rspec:install

# 2. API
$ docker compose exec web bundle exec rails generate rswag:api:install

# 3. UI
$ docker compose exec web bundle exec rails generate rswag:ui:install

# 4. Specs
$ docker compose exec web bundle exec rails generate rswag:specs:install
`
```

# Fluxo de Integração API → Jobs/Services → Pagarme & Asaas

## 1. Customer

1. **API /customer**
   - Recebe requisição para criação de um novo cliente.

2. **Job**
   - É disparado um **job assíncrono** responsável por orquestrar a criação do cliente.

3. **Gateways**
   - Criar **Customer no Pagarme**.
   - Criar **Customer no Asaas**.
   - Persistir os IDs de cada gateway associados ao customer local.

---

## 2. Subscription

1. **API /subscription**
   - Recebe requisição para criação de uma assinatura.

2. **Service**
   - Um service é chamado para processar a assinatura.

3. **Valida Customer**
   - Caso o **Customer não exista nos gateways**, cria automaticamente (reuso do fluxo anterior).

4. **Gateways**
   - Criar **Subscription no Pagarme**.
   - Criar **Subscription no Asaas**.
   - Salvar os IDs de subscription de cada gateway no banco local.

---



# Resumo Fluxo de Integração

## Customer
    +----------------+     +---------------+     +-------------------+
    |    Cliente     |     |     API       |     |       Job         |
    |  (Request)     |---->|  /customer    |---->| CreateCustomerJob |
    +----------------+     +---------------+     +-------------------+
                                                    |
                                                    v
                                      +-------------------+   +-------------------+
                                      | Pagarme Customer  |   |  Asaas Customer   |
                                      +-------------------+   +-------------------+


    ## Subscription
    +----------------+     +---------------+     +---------------------+
    |    Cliente     |     |     API       |     |       Service       |
    |  (Request)     |---->| /subscription |---->| CreateSubscription  |
    +----------------+     +---------------+     +---------------------+
                                                        |
                                                        v
                                      +-------------------+   +-------------------+
                                      | Pagarme Subscr.   |   |  Asaas Subscr.    |
                                      +-------------------+   +-------------------+



# observação

<h1 style="border-radius: 50%;"> Se este projeto te ajudou de uma forma não es queça de dar um start e mencionar o criador isso ajuda de uma forma ou outra </h1>



## 👨‍💻 Author

<div align="center">
  <img src="https://avatars.githubusercontent.com/u/5597266?s=400&v=4" width="100px" style="border-radius: 50%;" alt="Axel Alexander"/>

  **Axel Alexander **
  *Desenvolvedor Backend Python/Rails/Django/Net-core*

  [![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/axeldeveloper/)
  [![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/axeldeveloper)
  [![Email](https://img.shields.io/badge/-Email-EA4335?style=flat&logo=gmail&logoColor=white)](mailto:axelpatton@gmail.com)
</div>
