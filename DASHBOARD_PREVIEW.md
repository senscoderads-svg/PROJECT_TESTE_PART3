# Dashboard Grafana - Monitoramento de Wallets
## Representação Visual do Layout

Este documento mostra como o dashboard funcionando deve se parecer.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Monitoramento de Wallets                              Last 30 days  Refresh │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌──────────────────────────────────┐  ┌──────────────────────────────────┐  │
│  │ Série Temporal: Saldo das        │  │ Stat: Saldo Total Atual          │  │
│  │ Wallets                          │  │                                   │  │
│  │                                  │  │            145,823.50             │  │
│  │  ╱╲    ╱╲                        │  │                                   │  │
│  │ ╱  ╲  ╱  ╲  ╱╲                  │  │                                   │  │
│  │╱    ╲╱    ╲╱  ╲                │  │                                   │  │
│  │              ╲                 │  │                                   │  │
│  │  ─ Wallet 1   ─ Wallet 2       │  │                                   │  │
│  │  ─ Wallet 3   ─ Wallet 4       │  │                                   │  │
│  │                                  │  │                                   │  │
│  └──────────────────────────────────┘  └──────────────────────────────────┘  │
│                                                                               │
│  ┌──────────────────────────────────┐  ┌──────────────────────────────────┐  │
│  │ Tabela: Última Coleta            │  │ Gauge: Variação em 24h           │  │
│  │                                  │  │                                   │  │
│  │ Endereço              Saldo      │  │  Wallet 1      +2.5%  ▓▓░░░░░░░ │  │
│  │ 0x1234...789  45,250.00  14:32   │  │  Wallet 2      -1.2%  ░░░▓▓░░░░ │  │
│  │ 0xabcd...bcd  35,100.75  14:30   │  │  Wallet 3      +5.8%  ▓▓▓▓▓░░░░ │  │
│  │ 0xfedc...fed  40,250.25  14:28   │  │  Wallet 4      +0.3%  ░░░▓░░░░░ │  │
│  │ 0x9876...432  25,222.50  14:26   │  │                                   │  │
│  │                                  │  │                                   │  │
│  └──────────────────────────────────┘  └──────────────────────────────────┘  │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Dados Esperados no Dashboard

### 1. Série Temporal (Gráfico de Linhas)
- **Tipo**: Time Series Graph
- **Dados**: Últimos 30 dias de histórico
- **Linhas**: 4 linhas (uma por wallet)
- **Cores**: Diferentes cores para cada wallet
- **Eixo X**: Data/Hora
- **Eixo Y**: Saldo em unidades monetárias

### 2. Saldo Total (Stat)
- **Tipo**: Stat Panel
- **Valor**: Soma de todos os saldos mais recentes
- **Formato**: Número grande e legível
- **Exemplo**: 145,823.50
- **Atualização**: Última 24h

### 3. Tabela de Última Coleta
- **Tipo**: Table Panel
- **Colunas**:
  - Endereço da Wallet (0x...)
  - Saldo Atual (número)
  - Data da Coleta (timestamp)
- **Linhas**: 4 (uma por wallet monitorada)
- **Ordenação**: Por data mais recente

### 4. Gauge de Variação 24h
- **Tipo**: Gauge/Bar Chart Panel
- **Métrica**: Percentual de variação
- **Cores**:
  - 🔴 Vermelho: Negativo (< 0%)
  - 🟡 Amarelo: Neutro (= 0%)
  - 🟢 Verde: Positivo (> 10%)
- **Dados**: Últimas 24 horas

## Como Capturar o Screenshot Real

Para capturar um screenshot do dashboard funcionando:

1. **Abra o navegador:**
   ```
   http://localhost:3000
   ```

2. **Faça login:**
   - Usuário: `admin`
   - Senha: `admin`

3. **Acesse o Dashboard:**
   - Clique em **Dashboards** → **Browse**
   - Procure por **"Monitoramento de Wallets"**

4. **Tire o screenshot:**
   - Windows: `Print Screen`
   - Mac: `Cmd + Shift + 4`
   - Linux: `Print Screen` ou `Shift + Print`

5. **Salve como:**
   ```
   screenshot-dashboard.png
   ```

## Verificação de Dados

Para verificar os dados em tempo real, execute:

```bash
# Verificar wallets
docker exec wallets_db psql -U postgres -d wallets_db -c \
  "SELECT address, label FROM wallets ORDER BY address;"

# Verificar histórico recente
docker exec wallets_db psql -U postgres -d wallets_db -c \
  "SELECT w.address, h.balance, h.collected_at 
   FROM wallet_history h
   JOIN wallets w ON h.wallet_id = w.id
   ORDER BY h.collected_at DESC LIMIT 10;"

# Verificar saldo total
docker exec wallets_db psql -U postgres -d wallets_db -c \
  "SELECT SUM(balance) as total_balance
   FROM wallet_history
   WHERE (wallet_id, collected_at) IN (
     SELECT wallet_id, MAX(collected_at)
     FROM wallet_history
     GROUP BY wallet_id
   );"
```

## Status da Implementação ✓

- ✅ Grafana rodando localmente (porta 3000)
- ✅ PostgreSQL rodando (porta 5432)
- ✅ Datasource PostgreSQL configurado
- ✅ Dashboard com 4 painéis
- ✅ Queries SQL customizadas
- ✅ Dashboard exportado em JSON
- ⏳ Screenshot do dashboard (aguardando captura manual)

---

**Próximo passo**: Capture um screenshot real do dashboard e adicione a este README!
