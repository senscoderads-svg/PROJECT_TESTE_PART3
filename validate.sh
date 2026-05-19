#!/bin/bash
# Script de validação do projeto

echo "=================================================="
echo "VALIDAÇÃO DO PROJETO GRAFANA - WALLETS"
echo "=================================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para imprimir status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# 1. Verificar Docker Compose
echo "Verificando Docker Compose..."
docker-compose ps > /dev/null 2>&1
print_status $? "Docker Compose instalado e funcionando"
echo ""

# 2. Verificar containers
echo "Verificando containers..."
POSTGRES_RUNNING=$(docker ps --filter "name=wallets_db" --filter "status=running" -q)
if [ ! -z "$POSTGRES_RUNNING" ]; then
    print_status 0 "PostgreSQL container rodando"
else
    print_status 1 "PostgreSQL container NÃO está rodando"
fi

GRAFANA_RUNNING=$(docker ps --filter "name=grafana_wallets" --filter "status=running" -q)
if [ ! -z "$GRAFANA_RUNNING" ]; then
    print_status 0 "Grafana container rodando"
else
    print_status 1 "Grafana container NÃO está rodando"
fi
echo ""

# 3. Verificar banco de dados
echo "Verificando banco de dados..."
WALLET_COUNT=$(docker exec wallets_db psql -U postgres -d wallets_db -t -c "SELECT COUNT(*) FROM wallets;" 2>/dev/null)
if [ "$WALLET_COUNT" -gt 0 ]; then
    print_status 0 "Banco de dados com $WALLET_COUNT wallets"
else
    print_status 1 "Banco de dados vazio ou inacessível"
fi

HISTORY_COUNT=$(docker exec wallets_db psql -U postgres -d wallets_db -t -c "SELECT COUNT(*) FROM wallet_history;" 2>/dev/null)
if [ "$HISTORY_COUNT" -gt 0 ]; then
    print_status 0 "Histórico com $HISTORY_COUNT registros"
else
    print_status 1 "Histórico vazio ou inacessível"
fi
echo ""

# 4. Verificar Grafana
echo "Verificando Grafana..."
GRAFANA_HEALTH=$(curl -s http://localhost:3000/api/health)
if echo "$GRAFANA_HEALTH" | grep -q "ok"; then
    print_status 0 "Grafana respondendo em http://localhost:3000"
else
    print_status 1 "Grafana não está respondendo"
fi
echo ""

# 5. Verificar arquivos de configuração
echo "Verificando arquivos..."
[ -f "docker-compose.yml" ] && print_status 0 "docker-compose.yml encontrado" || print_status 1 "docker-compose.yml não encontrado"
[ -f ".env" ] && print_status 0 ".env encontrado" || print_status 1 ".env não encontrado"
[ -f "grafana/dashboard.json" ] && print_status 0 "dashboard.json encontrado" || print_status 1 "dashboard.json não encontrado"
[ -f "sql/00_init_database.sql" ] && print_status 0 "scripts SQL encontrados" || print_status 1 "scripts SQL não encontrados"
echo ""

# 6. Resumo
echo "=================================================="
echo "RESUMO"
echo "=================================================="
echo ""
echo "Acesse o Grafana em: http://localhost:3000"
echo "Credenciais: admin / admin"
echo ""
echo "Para capturar screenshot, execute:"
echo "  ./take-screenshot.sh"
echo ""
echo "Para mais informações, consulte:"
echo "  - README.md"
echo "  - SCREENSHOT_GUIDE.md"
echo ""
echo "=================================================="
