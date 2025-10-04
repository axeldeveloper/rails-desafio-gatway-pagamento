#!/bin/bash
# scripts/docker_reset.sh

echo "🔄 Resetting Docker environment..."

echo "1. Stopping all containers..."
docker compose down

echo "2. Removing orphan containers..."
docker compose down --remove-orphans

echo "3. Cleaning PID files..."
docker compose run --rm web bash -c "rm -f /rails/tmp/pids/server.pid"

echo "4. Rebuilding containers..."
docker compose build --no-cache

echo "5. Starting services..."
docker compose up -d

echo "✅ Environment reset complete!"
echo "📖 Access docs: http://localhost:3000/api-docs"
echo "🔍 Check logs: docker compose logs -f web"