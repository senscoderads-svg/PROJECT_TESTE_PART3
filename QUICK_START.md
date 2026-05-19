# 🚀 Quick Start - Dashboard Grafana

## Em 5 Minutos

### 1️⃣ Clone o Repositório
```bash
git clone https://github.com/senscoderads-svg/PROJECT_TESTE_PART3.git
cd PROJECT_TESTE_PART3
```

### 2️⃣ Inicie Tudo
```bash
docker-compose up -d
sleep 10
docker exec -i wallets_db psql -U postgres -d wallets_db < sql/00_init_database.sql
```

### 3️⃣ Acesse o Grafana
Abra seu navegador:
```
http://localhost:3000
```

**Login:**
- Usuário: `admin`
- Senha: `admin`

### 4️⃣ Veja o Dashboard
- Clique em **Dashboards** → **Browse**
- Procure por **"Monitoramento de Wallets"**
- Aguarde 5-10 segundos para carregar os dados

### 5️⃣ Tire um Screenshot
- **Windows**: `Print Screen`
- **Mac**: `Cmd + Shift + 4`
- **Linux**: `Print Screen` ou `Shift + Print`

Salve como: `screenshot-dashboard.png`

---

## ✅ Validar Instalação

```bash
bash validate.sh
```

Deve mostrar todos os itens com ✓

---

## 📞 Troubleshooting

### Grafana não abre
```bash
docker-compose ps
docker-compose logs grafana
```

### Dados não aparecem
```bash
docker exec wallets_db psql -U postgres -d wallets_db -c "SELECT COUNT(*) FROM wallet_history;"
```

### Resetar tudo
```bash
docker-compose down -v
docker-compose up -d
docker exec -i wallets_db psql -U postgres -d wallets_db < sql/00_init_database.sql
```

---

## 📚 Documentação Completa

- **Inicial**: README.md
- **Screenshots**: SCREENSHOT_GUIDE.md
- **Preview**: DASHBOARD_PREVIEW.md
- **Entrega**: DELIVERY_SUMMARY.md

---

**Tempo total**: ~5 minutos ⏱️
