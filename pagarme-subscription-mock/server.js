const jsonServer = require('json-server');
const path = require('path');

const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const middlewares = jsonServer.defaults();

// Middlewares padrão
server.use(middlewares);
server.use(jsonServer.bodyParser);

// Função para obter o db
function getDb() {
  return router.db;
}

// ========================================
// ROTAS CUSTOMIZADAS - ASAAS
// ========================================

// GET - Listar assinaturas Asaas
server.get('/asaas/subscriptions', (req, res) => {
  try {
    const db = getDb();
    const asaasData = db.get('asaas').value();
    const subscriptions = asaasData?.subscriptions || [];

    const { status, customer_id } = req.query;
    let filtered = subscriptions;

    if (status) {
      filtered = filtered.filter(sub => sub.status === status);
    }

    if (customer_id) {
      filtered = filtered.filter(sub => sub.customer_id === customer_id);
    }

    res.json({
      success: true,
      data: filtered,
      total: filtered.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// POST - Criar assinatura Asaas
server.post('/asaas/subscriptions', (req, res) => {
  try {
    const db = getDb();
    const newSubscription = req.body;

    if (!newSubscription.customer_id) {
      return res.status(400).json({
        success: false,
        error: 'customer_id é obrigatório'
      });
    }

    if (!newSubscription.plan_id) {
      return res.status(400).json({
        success: false,
        error: 'plan_id é obrigatório'
      });
    }

    newSubscription.id = generateId();
    newSubscription.status = newSubscription.status || 'active';
    newSubscription.created_at = new Date().toISOString();

    // Atualizar a estrutura aninhada
    const asaasData = db.get('asaas').value();
    asaasData.subscriptions.push(newSubscription);
    db.set('asaas', asaasData).write();

    res.status(201).json({
      success: true,
      data: newSubscription,
      message: 'Assinatura criada com sucesso'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET - Buscar assinatura Asaas por ID
server.get('/asaas/subscriptions/:id', (req, res) => {
  try {
    const db = getDb();
    const asaasData = db.get('asaas').value();
    const subscription = asaasData?.subscriptions?.find(sub => sub.id === req.params.id);

    if (!subscription) {
      return res.status(404).json({
        success: false,
        error: 'Assinatura não encontrada'
      });
    }

    res.json({
      success: true,
      data: subscription
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// PATCH - Atualizar assinatura Asaas
server.patch('/asaas/subscriptions/:id', (req, res) => {
  try {
    const db = getDb();
    const { id } = req.params;
    const updates = req.body;

    const asaasData = db.get('asaas').value();
    const index = asaasData.subscriptions.findIndex(sub => sub.id === id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        error: 'Assinatura não encontrada'
      });
    }

    asaasData.subscriptions[index] = {
      ...asaasData.subscriptions[index],
      ...updates,
      updated_at: new Date().toISOString()
    };

    db.set('asaas', asaasData).write();

    res.json({
      success: true,
      data: asaasData.subscriptions[index],
      message: 'Assinatura atualizada com sucesso'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// DELETE - Remover assinatura Asaas
server.delete('/asaas/subscriptions/:id', (req, res) => {
  try {
    const db = getDb();
    const { id } = req.params;

    const asaasData = db.get('asaas').value();
    const initialLength = asaasData.subscriptions.length;
    asaasData.subscriptions = asaasData.subscriptions.filter(sub => sub.id !== id);

    if (asaasData.subscriptions.length === initialLength) {
      return res.status(404).json({
        success: false,
        error: 'Assinatura não encontrada'
      });
    }

    db.set('asaas', asaasData).write();

    res.json({
      success: true,
      message: 'Assinatura removida com sucesso'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET - Listar customers Asaas
// https://docs.asaas.com/reference/list-customers
// Resposta de sucesso baseado no docs
server.get('/asaas/customers', (req, res) => {
  try {
    const db = getDb();
    const asaasData = db.get('asaas').value();
    let customers = asaasData?.customers || [];

    // Filtros por query
    const { name, cpfCnpj, email } = req.query;

    if (name) {
      customers = customers.filter(c =>
        c.name && c.name.toLowerCase().includes(name.toLowerCase())
      );
    }

    if (cpfCnpj) {
      customers = customers.filter(c => c.cpfCnpj === cpfCnpj);
    }

    if (email) {
      customers = customers.filter(c => c.email === email);
    }

    res.json({
      object: "list",
      success: true,
      data: customers,
      limit: 10,
      totalCount: customers.length
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// POST - Criar customer Asaas
// https://docs.asaas.com/reference/create-new-customer
// Resposta de sucesso baseado no docs
server.post('/asaas/customers', (req, res) => {
  try {
    const db = getDb();
    const newCustomer = req.body;

    if (!newCustomer.name || !newCustomer.email || !newCustomer.cpfCnpj) {
      return res.status(400).json({
        success: false,
        error: 'name, email e document são obrigatórios'
      });
    }

    newCustomer.id = generateId();
    newCustomer.object="customer";
    newCustomer.created_at = new Date().toISOString();

    const pagarmeData = db.get('asaas').value();
    pagarmeData.customers.push(newCustomer);
    db.set('asaas', pagarmeData).write();


    res.status(200).json(newCustomer);

    /*
    res.status(201).json({
      success: true,
      data: newCustomer,
      message: 'Cliente criado com sucesso'
    });*/


  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});




// ========================================
// ROTAS CUSTOMIZADAS - PAGARME
// ========================================

// GET - Listar assinaturas Pagarme
server.get('/pagarme/subscriptions', (req, res) => {
  try {
    const db = getDb();
    const pagarmeData = db.get('pagarme').value();
    const subscriptions = pagarmeData?.subscriptions || [];

    const { status, payment_method } = req.query;
    let filtered = subscriptions;

    if (status) {
      filtered = filtered.filter(sub => sub.status === status);
    }

    if (payment_method) {
      filtered = filtered.filter(sub => sub.payment_method === payment_method);
    }

    res.json({
      success: true,
      data: filtered,
      total: filtered.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// POST - Criar assinatura Pagarme
server.post('/pagarme/subscriptions', (req, res) => {
  try {
    const db = getDb();
    const newSubscription = req.body;

    if (!newSubscription.customer_id && !newSubscription.customer) {
      return res.status(400).json({
        success: false,
        error: 'customer_id ou customer é obrigatório'
      });
    }

    newSubscription.id = generateId();
    newSubscription.status = newSubscription.status || 'active';
    newSubscription.created_at = new Date().toISOString();

    const pagarmeData = db.get('pagarme').value();
    pagarmeData.subscriptions.push(newSubscription);
    db.set('pagarme', pagarmeData).write();

    res.status(201).json({
      success: true,
      data: newSubscription,
      message: 'Assinatura criada com sucesso'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET - Buscar assinatura Pagarme por ID
server.get('/pagarme/subscriptions/:id', (req, res) => {
  try {
    const db = getDb();
    const pagarmeData = db.get('pagarme').value();
    const subscription = pagarmeData?.subscriptions?.find(sub => sub.id === req.params.id);

    if (!subscription) {
      return res.status(404).json({
        success: false,
        error: 'Assinatura não encontrada'
      });
    }

    res.json({
      success: true,
      data: subscription
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// PATCH - Atualizar assinatura Pagarme
server.patch('/pagarme/subscriptions/:id', (req, res) => {
  try {
    const db = getDb();
    const { id } = req.params;
    const updates = req.body;

    const pagarmeData = db.get('pagarme').value();
    const index = pagarmeData.subscriptions.findIndex(sub => sub.id === id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        error: 'Assinatura não encontrada'
      });
    }

    pagarmeData.subscriptions[index] = {
      ...pagarmeData.subscriptions[index],
      ...updates,
      updated_at: new Date().toISOString()
    };

    db.set('pagarme', pagarmeData).write();

    res.json({
      success: true,
      data: pagarmeData.subscriptions[index],
      message: 'Assinatura atualizada com sucesso'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// DELETE - Remover assinatura Pagarme
server.delete('/pagarme/subscriptions/:id', (req, res) => {
  try {
    const db = getDb();
    const { id } = req.params;

    const pagarmeData = db.get('pagarme').value();
    const initialLength = pagarmeData.subscriptions.length;
    pagarmeData.subscriptions = pagarmeData.subscriptions.filter(sub => sub.id !== id);

    if (pagarmeData.subscriptions.length === initialLength) {
      return res.status(404).json({
        success: false,
        error: 'Assinatura não encontrada'
      });
    }

    db.set('pagarme', pagarmeData).write();

    res.json({
      success: true,
      message: 'Assinatura removida com sucesso'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET - Listar customers Pagarme
server.get('/pagarme/customers', (req, res) => {
  try {
    const db = getDb();
    const pagarmeData = db.get('pagarme').value();
    const customers = pagarmeData?.customers || [];

    const { document, email } = req.query;
    let filtered = customers;

    if (document) {
      filtered = filtered.filter(c => c.document === document);
    }

    if (email) {
      filtered = filtered.filter(c => c.email === email);
    }

    res.json({
      success: true,
      data: filtered,
      total: filtered.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// POST - Criar customer Pagarme
// https://docs.pagar.me/reference/criar-cliente-1
// Resposta de sucesso baseado no docs
server.post('/pagarme/customers', (req, res) => {
  try {
    const db = getDb();
    const newCustomer = req.body;

    if (!newCustomer.name || !newCustomer.email || !newCustomer.document) {
      return res.status(400).json({
        success: false,
        error: 'name, email e document são obrigatórios'
      });
    }

    newCustomer.id = generateId();
    newCustomer.created_at = new Date().toISOString();

    const pagarmeData = db.get('pagarme').value();
    pagarmeData.customers.push(newCustomer);
    db.set('pagarme', pagarmeData).write();
    res.status(200).json(newCustomer);

    /*res.status(201).json({
      success: true,
      data: newCustomer,
      message: 'Cliente criado com sucesso'
    });*/
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET - Listar erros Pagarme
server.get('/pagarme/errors', (req, res) => {
  try {
    const db = getDb();
    const pagarmeData = db.get('pagarme').value();
    const errors = pagarmeData?.errors || [];

    res.json({
      success: true,
      data: errors
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// ========================================
// ROTAS EXTRAS
// ========================================

// Health check
server.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString()
  });
});

// Listar todas as rotas disponíveis
server.get('/info', (req, res) => {
  res.json({
    message: 'API Faker - Asaas & Pagarme',
    routes: {
      asaas: {
        subscriptions: {
          'GET /asaas/subscriptions': 'Listar assinaturas',
          'GET /asaas/subscriptions/:id': 'Buscar assinatura por ID',
          'POST /asaas/subscriptions': 'Criar assinatura',
          'PATCH /asaas/subscriptions/:id': 'Atualizar assinatura',
          'DELETE /asaas/subscriptions/:id': 'Remover assinatura'
        },
        customers: {
          'GET /asaas/customers': 'Listar clientes'
        }
      },
      pagarme: {
        subscriptions: {
          'GET /pagarme/subscriptions': 'Listar assinaturas',
          'GET /pagarme/subscriptions/:id': 'Buscar assinatura por ID',
          'POST /pagarme/subscriptions': 'Criar assinatura',
          'PATCH /pagarme/subscriptions/:id': 'Atualizar assinatura',
          'DELETE /pagarme/subscriptions/:id': 'Remover assinatura'
        },
        customers: {
          'GET /pagarme/customers': 'Listar clientes (filtros: ?document=X ou ?email=Y)'
        },
        errors: {
          'GET /pagarme/errors': 'Listar erros'
        }
      },
      health: 'GET /health'
    }
  });
});

// ========================================
// USAR O ROUTER PADRÃO PARA OUTRAS ROTAS
// ========================================
server.use(router);

// ========================================
// FUNÇÕES AUXILIARES
// ========================================
function generateId() {
  return Math.random().toString(36).substr(2, 9);
}

// ========================================
// INICIAR SERVIDOR
// ========================================
const PORT = process.env.PORT || 3001;

server.listen(PORT, () => {
  console.log(`🚀 JSON Server rodando em http://localhost:${PORT}`);
  console.log('\n📋 Rotas disponíveis:');
  console.log(`   GET    http://localhost:${PORT}/`);
  console.log('   GET    /asaas/subscriptions');
  console.log('   POST   /asaas/subscriptions');
  console.log('   GET    /asaas/subscriptions/:id');
  console.log('   PATCH  /asaas/subscriptions/:id');
  console.log('   DELETE /asaas/subscriptions/:id');
  console.log('   GET    /asaas/customers');
  console.log('   GET    /pagarme/subscriptions');
  console.log('   POST   /pagarme/subscriptions');
  console.log('   GET    /pagarme/subscriptions/:id');
  console.log('   PATCH  /pagarme/subscriptions/:id');
  console.log('   DELETE /pagarme/subscriptions/:id');
  console.log('   GET    /pagarme/customers');
  console.log('   GET    /pagarme/errors');
  console.log('   GET    /health');
});