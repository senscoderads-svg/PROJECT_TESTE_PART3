#!/bin/bash
# Script para fazer screenshot do dashboard Grafana

echo "=================================================="
echo "Abrindo o Dashboard Grafana no navegador..."
echo "=================================================="
echo ""
echo "Você será redirecionado para: http://localhost:3000"
echo ""
echo "Login:"
echo "  Usuário: admin"
echo "  Senha: admin"
echo ""
echo "Passos para capturar o screenshot:"
echo "1. Após fazer login, vá para Dashboards > Browse"
echo "2. Clique em 'Monitoramento de Wallets'"
echo "3. Aguarde o carregamento dos painéis (cerca de 5-10 segundos)"
echo "4. Tire um screenshot (Print Screen ou Cmd+Shift+4 no Mac)"
echo "5. Salve como 'screenshot-dashboard.png' na raiz do projeto"
echo "6. Commit o arquivo: git add screenshot-dashboard.png && git commit -m 'Add dashboard screenshot'"
echo ""
echo "Abrindo navegador..."
echo ""

# Tenta abrir no navegador padrão
if command -v xdg-open > /dev/null; then
    xdg-open http://localhost:3000
elif command -v open > /dev/null; then
    open http://localhost:3000
else
    echo "Abra manualmente: http://localhost:3000"
fi

echo "Pressione Enter para fechar..."
read
