-- Query para Stat: Saldo total atual somando todas as wallets monitoradas
SELECT 
    COALESCE(SUM(h.balance), 0) as total_balance
FROM wallet_history h
WHERE (h.wallet_id, h.collected_at) IN (
    SELECT wallet_id, MAX(collected_at)
    FROM wallet_history
    WHERE collected_at >= now() - interval '1 day'
    GROUP BY wallet_id
);
