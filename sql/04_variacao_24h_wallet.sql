-- Query para Bar Chart/Gauge: Variação percentual das últimas 24h por wallet
SELECT 
    w.address as wallet_address,
    ROUND(
        ((saldo_atual - saldo_24h_atrás) / NULLIF(saldo_24h_atrás, 0)) * 100,
        2
    ) as variacao_percentual
FROM (
    SELECT 
        h_atual.wallet_id,
        h_atual.balance as saldo_atual,
        COALESCE(h_passado.balance, h_atual.balance) as saldo_24h_atrás
    FROM (
        SELECT wallet_id, balance, collected_at
        FROM wallet_history
        WHERE (wallet_id, collected_at) IN (
            SELECT wallet_id, MAX(collected_at)
            FROM wallet_history
            WHERE collected_at >= now() - interval '1 day'
            GROUP BY wallet_id
        )
    ) h_atual
    LEFT JOIN (
        SELECT wallet_id, balance, collected_at
        FROM wallet_history
        WHERE (wallet_id, collected_at) IN (
            SELECT wallet_id, MAX(collected_at)
            FROM wallet_history
            WHERE collected_at >= now() - interval '2 days'
            AND collected_at < now() - interval '1 day'
            GROUP BY wallet_id
        )
    ) h_passado ON h_atual.wallet_id = h_passado.wallet_id
) variacao_24h
JOIN wallets w ON variacao_24h.wallet_id = w.id
ORDER BY variacao_percentual DESC;
