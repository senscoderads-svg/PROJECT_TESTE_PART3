-- Query para Tabela: Última coleta de cada wallet
SELECT 
    w.address as wallet_address,
    h.balance as saldo_atual,
    h.collected_at as data_coleta
FROM wallet_history h
JOIN wallets w ON h.wallet_id = w.id
WHERE (h.wallet_id, h.collected_at) IN (
    SELECT wallet_id, MAX(collected_at)
    FROM wallet_history
    GROUP BY wallet_id
)
ORDER BY h.collected_at DESC;
