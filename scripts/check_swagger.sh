#!/bin/bash
# scripts/check_swagger.sh

echo "=== Verificando Swagger Setup ==="

echo "1. Verificando rotas..."
docker compose exec web bundle exec rails routes | grep -E "(api-docs|health)"

echo -e "\n2. Verificando arquivos de configuração..."
docker compose exec web ls -la config/initializers/rswag*

echo -e "\n3. Verificando swagger_helper..."
docker compose exec web ls -la spec/swagger_helper.rb

echo -e "\n4. Verificando documentação gerada..."
docker compose exec web find swagger/ -type f

echo -e "\n5. Testando health endpoint..."
curl -s http://localhost:3000/api/v1/health | jq .

echo -e "\n6. Testando swagger UI..."
curl -s -o /dev/null -w "%{http_code}" http://localhost/api-docs

echo -e "\n=== Verificação completa ==="