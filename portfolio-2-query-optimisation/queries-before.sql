EXPLAIN (ANALYZE, BUFFERS)
SELECT
    transfer_id,
    amount,
    status,
    created_at
FROM banking.transfers
WHERE status = 'COMPLETED'
  AND created_at >= '2026-06-01'
ORDER BY created_at DESC
LIMIT 50;



EXPLAIN (ANALYZE, BUFFERS)
SELECT
    transfer_id,
    destination_account_id,
    amount,
    created_at
FROM banking.transfers
WHERE destination_account_id = 1000002
ORDER BY created_at DESC;


EXPLAIN (ANALYZE, BUFFERS)
SELECT
    transfer_id,
    amount,
    status
FROM banking.transfers
WHERE status = 'COMPLETED'
  AND amount BETWEEN 50000 AND 70000;