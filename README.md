# Dashboard Grafana - Monitoramento de Wallets

Um dashboard completo em Grafana para monitorar wallets em tempo real, lendo dados diretamente do PostgreSQL.

## 📋 Requisitos

- Docker e Docker Compose instalados
- Git instalado
- Porta 3000 disponível (Grafana)
- Porta 5432 disponível (PostgreSQL)

## 🚀 Começando

### 1. Clone o repositório

```bash
git clone https://github.com/senscoderads-svg/PROJECT_TESTE_PART3.git
cd PROJECT_TESTE_PART3
```

### 2. Inicie os serviços

```bash
docker-compose up -d
```

Isso irá iniciar:
- **PostgreSQL** na porta 5432
- **Grafana** na porta 3000

### 3. Acesse o Grafana

Abra seu navegador e acesse:
```
http://localhost:3000
```

Credenciais padrão:
- **Usuário**: admin
- **Senha**: admin

### 4. Inicialize o banco de dados

Conecte ao PostgreSQL e execute o script de inicialização:

```bash
docker exec -i wallets_db psql -U postgres -d wallets_db < sql/00_init_database.sql
```

Ou se preferir via Docker:
```bash
docker exec -i wallets_db psql -U postgres -d wallets_db < sql/00_init_database.sql
```

### 5. Visualize o Dashboard

Após a inicialização, o dashboard deve estar disponível automaticamente no Grafana. 
Se não aparecer, acesse manualmente:
- Vá para **Dashboards** → **Browse** → **Monitoramento de Wallets**

## 📊 Painéis do Dashboard

### 1. **Série Temporal: Saldo das Wallets**
- Mostra a evolução do saldo de cada wallet ao longo do tempo
- Gráfico de linhas com até 30 dias de histórico
- Cores diferentes para cada wallet
- **Query**: `sql/01_serie_temporal_saldo.sql`

### 2. **Stat: Saldo Total Atual**
- Exibe o saldo total consolidado de todas as wallets
- Soma dos saldos mais recentes (última 24h)
- **Query**: `sql/02_saldo_total_atual.sql`

### 3. **Tabela: Última Coleta de Cada Wallet**
- Mostra informações de cada wallet monitorada
- Colunas: Endereço, Saldo Atual, Data da Coleta
- Ordena por data mais recente
- **Query**: `sql/03_ultima_coleta_wallet.sql`

### 4. **Gauge: Variação Percentual em 24h**
- Exibe a variação de saldo em percentual nos últimos 24 horas
- Indicadores de cores: Vermelho (negativo), Amarelo (zero), Verde (positivo)
- **Query**: `sql/04_variacao_24h_wallet.sql`

## 🗄️ Estrutura do Banco de Dados

### Tabela: `wallets`
```sql
- id: Identificador único
- address: Endereço da wallet (único)
- label: Descrição/nome da wallet
- created_at: Data de criação
- updated_at: Data de atualização
```

### Tabela: `wallet_history`
```sql
- id: Identificador único
- wallet_id: Referência para tabela wallets
- balance: Saldo atual
- collected_at: Timestamp da coleta
- created_at: Data de criação
```

## 🔌 Integração com Projeto 2

A conexão com o banco de dados do Projeto 2 é feita via datasource PostgreSQL configurado em:
```
grafana/provisioning/datasources/postgresql.yml
```

Para conectar com um banco externo, altere:
```yaml
url: seu_host_postgresql:5432
database: seu_banco
user: seu_usuario
password: sua_senha
```

## 📝 Queries SQL Personalizadas

Todas as queries dos painéis foram escritas customizadas para este projeto:

1. **Série Temporal** - Retorna histórico completo de saldos com timestamp
2. **Saldo Total** - Suma dinamicamente os últimos saldos conhecidos
3. **Última Coleta** - Agrupa por wallet e pega apenas a coleta mais recente
4. **Variação 24h** - Compara saldo atual com saldo de 24 horas atrás

## 🔄 Atualizar Dashboard

Para modificar painéis no Grafana:
1. Faça as alterações diretamente na interface
2. Clique no ícone de configuração (engrenagem) > **Salvar**
3. Exporte o dashboard em JSON clicando em **Share** → **Export**
4. Salve o JSON em `grafana/dashboard.json`
5. Reinicie o Grafana: `docker-compose restart grafana`

**Nota**: As queries SQL estão documentadas em `sql/` e podem ser modificadas conforme necessário.

## 📊 Print do Dashboard

*Dashboard funcionando corretamente com todos os painéis carregando dados:*

Para capturar um screenshot do dashboard, consulte o guia: [SCREENSHOT_GUIDE.md](SCREENSHOT_GUIDE.md)

**Como tirar o screenshot:**
```bash
./take-screenshot.sh
```

Ou acesse manualmente: http://localhost:3000 (credenciais: admin/admin)

## 🛠️ Troubleshooting

### Grafana não consegue conectar ao PostgreSQL
```bash
# Verifique se o container postgres está rodando
docker-compose ps

# Verifique os logs
docker-compose logs postgres
docker-compose logs grafana
```

### Dados não aparecem no dashboard
```bash
# Certifique-se de que os dados foram inseridos
docker exec wallets_db psql -U postgres -d wallets_db -c "SELECT * FROM wallet_history LIMIT 5;"
```

### Resetar tudo
```bash
# Parar containers
docker-compose down

# Remover volumes (CUIDADO: deleta dados!)
docker-compose down -v

# Iniciar novamente
docker-compose up -d
```

## 📦 Variáveis de Ambiente

Personalize no arquivo `.env`:
- `DB_PORT`: Porta do PostgreSQL (padrão: 5432)
- `DB_NAME`: Nome do banco de dados (padrão: wallets_db)
- `DB_USER`: Usuário do banco (padrão: postgres)
- `DB_PASSWORD`: Senha do banco (padrão: postgres)
- `GRAFANA_PORT`: Porta do Grafana (padrão: 3000)
- `GRAFANA_PASSWORD`: Senha do admin Grafana (padrão: admin)

## 🔐 Produção

Para usar em produção:

1. Altere senhas padrão em `.env`
2. Configure HTTPS no Grafana
3. Use volumes persistentes adequados
4. Configure backups regulares do banco de dados
5. Configure alertas no Grafana
6. Implemente monitoramento do próprio Grafana

## � Estrutura do Projeto

```
PROJECT_TESTE_PART3/
├── docker-compose.yml          # Configuração dos containers
├── .env                        # Variáveis de ambiente
├── README.md                   # Este arquivo
├── SCREENSHOT_GUIDE.md         # Guia para capturar screenshot
├── take-screenshot.sh          # Script auxiliar
├── LICENSE                     # Licença MIT
├── grafana/
│   ├── dashboard.json         # Dashboard JSON exportado
│   └── provisioning/
│       ├── datasources/
│       │   └── postgresql.yml # Configuração do datasource
│       └── dashboards/
│           └── dashboard-provider.yml
└── sql/
    ├── 00_init_database.sql           # Script de inicialização
    ├── 01_serie_temporal_saldo.sql    # Query - Série temporal
    ├── 02_saldo_total_atual.sql       # Query - Stat
    ├── 03_ultima_coleta_wallet.sql    # Query - Tabela
    └── 04_variacao_24h_wallet.sql     # Query - Gauge
```

## �📚 Documentação Oficial

- [Grafana](https://grafana.com/docs/)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [Docker Compose](https://docs.docker.com/compose/)

## 📄 Licença

MIT License - veja LICENSE para detalhes

## 👤 Autor

Projeto desenvolvido como parte do currículo de monitoramento de criptomoedas.

---

**Última atualização**: Maio 2026
