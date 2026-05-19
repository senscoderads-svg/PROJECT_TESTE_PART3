# Guia Detalhado - Capturar Screenshot do Dashboard

## Como Tirar o Screenshot do Dashboard Grafana

### Opção 1: Pelo Terminal (Recomendado)

```bash
# Executar o script de screenshot
chmod +x take-screenshot.sh
./take-screenshot.sh
```

### Opção 2: Manualmente via Navegador

1. **Abra o navegador** e acesse:
   ```
   http://localhost:3000
   ```

2. **Faça login** com as credenciais padrão:
   - Usuário: `admin`
   - Senha: `admin`

3. **Navegue para o Dashboard**:
   - Clique em **Dashboards** (no menu lateral)
   - Clique em **Browse**
   - Procure por **"Monitoramento de Wallets"**
   - Clique para abrir

4. **Aguarde o Carregamento**:
   - Os painéis devem carregar em 5-10 segundos
   - Se os dados não aparecerem, verifique:
     ```bash
     docker-compose logs grafana
     docker-compose logs postgres
     ```

5. **Tire o Screenshot**:
   - **Windows**: Pressione `Print Screen` ou `Shift + Windows + S`
   - **Mac**: Pressione `Cmd + Shift + 4` (depois selecione a área)
   - **Linux**: Use `Screenshot` ou `Shift + Print Screen`

6. **Salve a Imagem**:
   - Nomeie como: `screenshot-dashboard.png`
   - Salve na raiz do projeto:
     ```
     PROJECT_TESTE_PART3/
     ├── screenshot-dashboard.png
     ├── README.md
     └── ...
     ```

7. **Commit no Git**:
   ```bash
   git add screenshot-dashboard.png
   git commit -m "Add dashboard screenshot"
   git push origin main
   ```

### O Que Deve Aparecer no Screenshot

Você deve ver 4 painéis:

1. **Série Temporal** (canto superior esquerdo)
   - Gráfico de linhas com evolução dos saldos
   - Múltiplas linhas coloridas (uma por wallet)

2. **Saldo Total** (canto superior direito)
   - Um grande número mostrando a soma de todos os saldos

3. **Tabela** (canto inferior esquerdo)
   - 3 colunas: Endereço da Wallet, Saldo Atual, Data da Coleta
   - 4 linhas (uma para cada wallet)

4. **Gauge de Variação** (canto inferior direito)
   - Percentuais de variação das últimas 24h
   - Cores: Vermelho (negativo), Amarelo (zero), Verde (positivo)

## Troubleshooting do Screenshot

### Os painéis não estão carregando dados

```bash
# Verifique se os dados estão no banco
docker exec wallets_db psql -U postgres -d wallets_db -c \
  "SELECT COUNT(*) FROM wallet_history;"

# Se retornar 0, reinicialize o banco:
docker exec -i wallets_db psql -U postgres -d wallets_db < sql/00_init_database.sql
```

### Grafana não abre

```bash
# Verifique se o container está rodando
docker-compose ps

# Se não estiver, reinicie:
docker-compose restart grafana
```

### Problema de autenticação

- Credenciais padrão: `admin` / `admin`
- Se não funcionar, resete o Grafana:
  ```bash
  docker-compose down
  docker-compose up -d
  sleep 10
  docker exec -i wallets_db psql -U postgres -d wallets_db < sql/00_init_database.sql
  ```

## Dicas de Captura

- **Melhor Resolução**: Maximize o navegador antes de fazer o screenshot
- **Layout**: O dashboard está otimizado para telas largas (1920x1080 ou maior)
- **Escala**: Se usar Zoom no navegador, redimensione para 100%
- **Tempo**: Aguarde 5 segundos após abrir para os dados carregarem completamente

---

**Próximo passo**: Após capturar a imagem, atualize o README com a imagem e faça o commit final!
