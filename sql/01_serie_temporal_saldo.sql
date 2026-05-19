-- Query para Série Temporal: Saldo das wallets ao longo do tempo
-- Retorna: wallet_address, saldo, timestamp
SELECT 
    w.address as wallet_address,
    h.balance as saldo,
    h.collected_at as time
FROM wallet_history h
JOIN wallets w ON h.wallet_id = w.id
WHERE h.collected_at >= now() - interval '30 days'
ORDER BY h.collected_at ASC, w.address ASC;
