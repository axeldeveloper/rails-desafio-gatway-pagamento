# 📦 Project
### pagarme-subscription-mock

Mock de API para simular endpoints de assinaturas e clientes, utilizando [json-server](https://github.com/typicode/json-server).


# 🚀 API Faker - Asaas & Pagarme Mock

API simulada para testes de integração com gateways de pagamento brasileiros (Asaas e Pagarme), construída com JSON Server.

## 📋 Índice

- [Instalação](#-instalação)
- [Configuração](#️-configuração)
- [Iniciando o Servidor](#-iniciando-o-servidor)
- [Rotas Disponíveis](#-rotas-disponíveis)
- [Exemplos de Uso](#-exemplos-de-uso)
- [Estrutura do Projeto](#-estrutura-do-projeto)

---

## 📦 Instalação

### Pré-requisitos

- Node.js (versão 18 ou superior)
- npm ou yarn

### Passo a passo

1. **Clone ou acesse o projeto:**

```bash
cd pagarme-subscription-mock
```

2. **Crie os arquivos necessários:**

Crie o arquivo `package.json`:

```json
{
  "name": "pagarme-subscription-mock",
  "version": "1.0.0",
  "description": "API Faker com JSON Server customizado",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "json-server": "^0.17.4"
  },
  "devDependencies": {
    "nodemon": "^3.1.10"
  }
}
```

3. **Instale as dependências:**

```bash
npm install
```

---

## ⚙️ Configuração

### Estrutura do db.json

Crie o arquivo `db.json` na raiz do projeto com a seguinte estrutura:

```json
{
  "asaas": {
    "customers": [], /* campos de acordo com a documentação das api de pagamento*/
    "subscriptions": []
  },
  "pagarme": {
    "subscriptions": [],
    "customers": [],
    "errors": []
  }
}
```

O arquivo `server.js` já está configurado para trabalhar com essa estrutura aninhada.

---

## 🎮 Iniciando o Servidor

### Modo Desenvolvimento (com auto-reload)

```bash
npm run dev
```

### Modo Produção

```bash
npm start
```

O servidor estará disponível em:
```
http://localhost:3001
```

---

## 📍 Rotas Disponíveis

### 🏠 Home

```http
GET /
```

Retorna a lista completa de todas as rotas disponíveis.

### 🔵 Asaas

#### Subscriptions (Assinaturas)

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/asaas/subscriptions` | Listar todas as assinaturas |
| `GET` | `/asaas/subscriptions/:id` | Buscar assinatura por ID |
| `POST` | `/asaas/subscriptions` | Criar nova assinatura |
| `PATCH` | `/asaas/subscriptions/:id` | Atualizar assinatura |
| `DELETE` | `/asaas/subscriptions/:id` | Remover assinatura |

**Query Params para GET:**
- `?status=active` - Filtrar por status
- `?customer_id=cus_123` - Filtrar por cliente

#### Customers (Clientes)

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/asaas/customers` | Listar todos os clientes |

---

### 🟢 Pagarme

#### Subscriptions (Assinaturas)

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/pagarme/subscriptions` | Listar todas as assinaturas |
| `GET` | `/pagarme/subscriptions/:id` | Buscar assinatura por ID |
| `POST` | `/pagarme/subscriptions` | Criar nova assinatura |
| `PATCH` | `/pagarme/subscriptions/:id` | Atualizar assinatura |
| `DELETE` | `/pagarme/subscriptions/:id` | Remover assinatura |

**Query Params para GET:**
- `?status=active` - Filtrar por status
- `?payment_method=credit_card` - Filtrar por método de pagamento

#### Customers (Clientes)

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/pagarme/customers` | Listar todos os clientes |

**Query Params para GET:**
- `?document=01516168178` - Filtrar por CPF/CNPJ
- `?email=email@example.com` - Filtrar por email

#### Errors (Erros)

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/pagarme/errors` | Listar erros simulados |

---

### 🏥 Health Check

```http
GET /health
```

Verifica se a API está funcionando.

---

## 💡 Exemplos de Uso

### 1. Listar Todas as Rotas

```bash
curl http://localhost:3001/
```

**Resposta:**
```json
{
  "message": "API Faker - Asaas & Pagarme",
  "routes": {
    "asaas": {...},
    "pagarme": {...}
  }
}
```

---

### 2. Asaas - Criar Assinatura

```bash
curl -X POST http://localhost:3001/asaas/subscriptions \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "cus_123456",
    "plan_id": "plan_premium_001",
    "payment_method": "credit_card",
    "status": "active"
  }'
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "customer_id": "cus_123456",
    "plan_id": "plan_premium_001",
    "payment_method": "credit_card",
    "status": "active",
    "id": "a7b3c9d2e",
    "created_at": "2025-09-30T10:30:00.000Z"
  },
  "message": "Assinatura criada com sucesso"
}
```

---

### 3. Asaas - Listar Assinaturas

```bash
# Listar todas
curl http://localhost:3001/asaas/subscriptions

# Filtrar por status
curl http://localhost:3001/asaas/subscriptions?status=active

# Filtrar por customer_id
curl http://localhost:3001/asaas/subscriptions?customer_id=cus_123456
```

**Resposta:**
```json
{
  "success": true,
  "data": [
    {
      "customer_id": "cus_123456",
      "plan_id": "plan_premium_001",
      "payment_method": "credit_card",
      "status": "active",
      "id": "a7b3c9d2e",
      "created_at": "2025-09-30T10:30:00.000Z"
    }
  ],
  "total": 1
}
```

---

### 4. Asaas - Buscar Assinatura por ID

```bash
curl http://localhost:3001/asaas/subscriptions/a7b3c9d2e
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "customer_id": "cus_123456",
    "plan_id": "plan_premium_001",
    "payment_method": "credit_card",
    "status": "active",
    "id": "a7b3c9d2e",
    "created_at": "2025-09-30T10:30:00.000Z"
  }
}
```

---

### 5. Asaas - Atualizar Assinatura

```bash
curl -X PATCH http://localhost:3001/asaas/subscriptions/a7b3c9d2e \
  -H "Content-Type: application/json" \
  -d '{
    "status": "cancelled"
  }'
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "customer_id": "cus_123456",
    "plan_id": "plan_premium_001",
    "payment_method": "credit_card",
    "status": "cancelled",
    "id": "a7b3c9d2e",
    "created_at": "2025-09-30T10:30:00.000Z",
    "updated_at": "2025-09-30T11:45:00.000Z"
  },
  "message": "Assinatura atualizada com sucesso"
}
```

---

### 6. Asaas - Deletar Assinatura

```bash
curl -X DELETE http://localhost:3001/asaas/subscriptions/a7b3c9d2e
```

**Resposta:**
```json
{
  "success": true,
  "message": "Assinatura removida com sucesso"
}
```

---

### 7. Pagarme - Criar Assinatura

```bash
curl -X POST http://localhost:3001/pagarme/subscriptions \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "cus_789",
    "plan_id": "plan_basic_001",
    "payment_method": "boleto"
  }'
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "customer_id": "cus_789",
    "plan_id": "plan_basic_001",
    "payment_method": "boleto",
    "id": "f4e5d6c7b",
    "status": "active",
    "created_at": "2025-09-30T10:30:00.000Z"
  },
  "message": "Assinatura criada com sucesso"
}
```

---

### 8. Pagarme - Listar Assinaturas

```bash
# Listar todas
curl http://localhost:3001/pagarme/subscriptions

# Filtrar por status
curl http://localhost:3001/pagarme/subscriptions?status=active

# Filtrar por método de pagamento
curl http://localhost:3001/pagarme/subscriptions?payment_method=credit_card
```

---

### 9. Pagarme - Listar Clientes

```bash
# Listar todos
curl http://localhost:3001/pagarme/customers

# Filtrar por documento
curl http://localhost:3001/pagarme/customers?document=01516168178

# Filtrar por email
curl http://localhost:3001/pagarme/customers?email=axel.silva@example.com
```

---

### 10. Pagarme - Listar Erros

```bash
curl http://localhost:3001/pagarme/errors
```

**Resposta:**
```json
{
  "success": true,
  "data": [
    {
      "error": "invalid_card",
      "message": "Cartão recusado pelo emissor.",
      "id": "516e"
    },
    {
      "error": "plan_not_found",
      "message": "Plano inexistente.",
      "id": "95ab"
    }
  ]
}
```

---

### 11. Health Check

```bash
curl http://localhost:3001/health
```

**Resposta:**
```json
{
  "status": "ok",
  "timestamp": "2025-09-30T10:30:00.000Z"
}
```

---

## 🧪 Testando com JavaScript/TypeScript

### Exemplo com Fetch API

```javascript
// Criar assinatura
const createSubscription = async () => {
  const response = await fetch('http://localhost:3001/asaas/subscriptions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      customer_id: 'cus_123456',
      plan_id: 'plan_premium_001',
      payment_method: 'credit_card'
    })
  });

  const data = await response.json();
  console.log(data);
};

// Listar assinaturas
const listSubscriptions = async () => {
  const response = await fetch('http://localhost:3001/asaas/subscriptions?status=active');
  const data = await response.json();
  console.log(data);
};
```

### Exemplo com Axios

```javascript
const axios = require('axios');

// Criar assinatura
const createSubscription = async () => {
  try {
    const response = await axios.post('http://localhost:3001/asaas/subscriptions', {
      customer_id: 'cus_123456',
      plan_id: 'plan_premium_001',
      payment_method: 'credit_card'
    });
    console.log(response.data);
  } catch (error) {
    console.error(error.response.data);
  }
};

// Listar assinaturas
const listSubscriptions = async () => {
  try {
    const response = await axios.get('http://localhost:3001/asaas/subscriptions', {
      params: { status: 'active' }
    });
    console.log(response.data);
  } catch (error) {
    console.error(error.response.data);
  }
};
```

---

## 📂 Estrutura do Projeto

```
pagarme-subscription-mock/
├── db.json                 # Banco de dados JSON
├── server.js               # Servidor customizado
├── package.json            # Dependências do projeto
├── package-lock.json       # Lock de dependências
├── node_modules/           # Módulos instalados
└── README.md               # Este arquivo
```

---

## ✨ Recursos

✅ **Validações automáticas** - Campos obrigatórios são validados
✅ **IDs únicos** - Geração automática de IDs para novos registros
✅ **Timestamps** - `created_at` e `updated_at` automáticos
✅ **Filtros** - Query params para filtrar resultados
✅ **Respostas padronizadas** - Formato consistente com `success`, `data`, `message`
✅ **Tratamento de erros** - Mensagens claras de erro
✅ **CRUD completo** - Create, Read, Update, Delete
✅ **Estrutura aninhada** - Suporte para JSON aninhado

---

## 🔧 Personalizações

### Adicionar novas rotas

Edite o arquivo `server.js` e adicione novas rotas:

```javascript
server.get('/sua-rota', (req, res) => {
  try {
    // Sua lógica aqui
    res.json({
      success: true,
      data: []
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});
```

### Mudar a porta

```bash
# Linux/Mac
PORT=4000 npm start

# Windows (CMD)
set PORT=4000 && npm start

# Windows (PowerShell)
$env:PORT=4000; npm start
```

---

## 🐛 Troubleshooting

### Erro: "Cannot find module 'json-server'"

```bash
npm install json-server --save
```

### Erro: "EADDRINUSE: address already in use"

A porta 3000 já está em uso. Mate o processo ou use outra porta:

```bash
# Descobrir qual processo está usando a porta 3000
lsof -i :3000

# Matar o processo
kill -9 <PID>

# Ou usar outra porta
PORT=4000 npm start
```

### Erro: "Cannot read properties of undefined"

Verifique se o `db.json` está no formato correto e no mesmo diretório do `server.js`.

---

## 📝 Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

---

## 🤝 Contribuindo

Sinta-se à vontade para abrir issues ou enviar pull requests!

---

## 📞 Suporte

Se encontrar algum problema ou tiver dúvidas, abra uma issue no repositório.

---

**Feito com ❤️ para facilitar seus testes de integração com gateways de pagamento brasileiros!**