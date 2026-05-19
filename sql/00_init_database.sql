-- Script de inicialização: Criar tabelas para armazenar dados de wallets
-- Este script deve ser executado uma vez quando o banco de dados for criado

CREATE TABLE IF NOT EXISTS wallets (
    id SERIAL PRIMARY KEY,
    address VARCHAR(255) NOT NULL UNIQUE,
    label VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS wallet_history (
    id SERIAL PRIMARY KEY,
    wallet_id INTEGER NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
    balance NUMERIC(38, 18) NOT NULL,
    collected_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(wallet_id, collected_at)
);

-- Criar índices para otimizar as queries
CREATE INDEX IF NOT EXISTS idx_wallet_history_wallet_id ON wallet_history(wallet_id);
CREATE INDEX IF NOT EXISTS idx_wallet_history_collected_at ON wallet_history(collected_at);
CREATE INDEX IF NOT EXISTS idx_wallet_history_wallet_collected ON wallet_history(wallet_id, collected_at);

-- Dados de exemplo para teste
INSERT INTO wallets (address, label) VALUES
    ('0x1234567890abcdef1234567890abcdef12345678', 'Wallet 1 - Principal'),
    ('0xabcdefabcdefabcdefabcdefabcdefabcdefabcd', 'Wallet 2 - Reserve'),
    ('0xfedcbafedcbafedcbafedcbafedcbafedcbafed', 'Wallet 3 - Operacional'),
    ('0x9876543210fedcba9876543210fedcba98765432', 'Wallet 4 - Colateral')
ON CONFLICT (address) DO NOTHING;

-- Gerar dados históricos de exemplo (últimos 30 dias)
INSERT INTO wallet_history (wallet_id, balance, collected_at)
SELECT 
    w.id,
    ROUND((RANDOM() * 100 + 50)::numeric, 18),
    CURRENT_TIMESTAMP - interval '1 day' * (30 - day_offset) + interval '1 hour' * hour_offset
FROM wallets w
CROSS JOIN LATERAL (
    SELECT day_offset, hour_offset
    FROM generate_series(0, 29) AS t1(day_offset)
    CROSS JOIN generate_series(0, 23, 6) AS t2(hour_offset)
) AS dates
WHERE w.address IN (
    '0x1234567890abcdef1234567890abcdef12345678',
    '0xabcdefabcdefabcdefabcdefabcdefabcdefabcd',
    '0xfedcbafedcbafedcbafedcbafedcbafedcbafed',
    '0x9876543210fedcba9876543210fedcba98765432'
)
ON CONFLICT (wallet_id, collected_at) DO NOTHING;

-- Verificar se os dados foram inseridos corretamente
SELECT COUNT(*) as total_wallets FROM wallets;
SELECT COUNT(*) as total_historico FROM wallet_history;
