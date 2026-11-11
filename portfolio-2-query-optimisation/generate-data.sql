-- NOVABANK PORTFOLIO 2
-- Generate synthetic data for query optimisation

BEGIN;

-- 1. Generate 10,000 customers
INSERT INTO banking.customers (
    customer_id,
    full_name,
    email
)
OVERRIDING SYSTEM VALUE
SELECT
    1000000 + n,
    'Test Customer ' || n,
    'testcustomer' || n || '@novabank.test'
FROM generate_series(1, 10000) AS n;


-- 2. Generate 10,000 accounts
INSERT INTO banking.accounts (
    account_id,
    customer_id,
    account_number,
    currency,
    status
)
OVERRIDING SYSTEM VALUE
SELECT
    1000000 + n,
    1000000 + n,
    '2' || LPAD(n::text, 9, '0'),
    'NGN',
    'ACTIVE'
FROM generate_series(1, 10000) AS n;

-- 3. Generate 100,000 transfers
INSERT INTO banking.transfers (
    transfer_id,
    idempotency_key,
    source_account_id,
    destination_account_id,
    amount,
    currency,
    status,
    created_at,
    completed_at
)
OVERRIDING SYSTEM VALUE
SELECT
    2000000 + n,
    (
        LPAD(TO_HEX(2000000 + n), 8, '0') ||
        '-0000-4000-8000-' ||
        LPAD(TO_HEX(n), 12, '0')
    )::uuid,
    1000001 + ((n - 1) % 10000),
    1000001 + (n % 10000),
    ROUND((1000 + RANDOM() * 99000)::numeric, 2),
    'NGN',
    CASE
        WHEN n % 10 = 0 THEN 'PENDING'
        WHEN n % 10 = 1 THEN 'FAILED'
        ELSE 'COMPLETED'
    END,
    generated_at,
    CASE
        WHEN n % 10 IN (0, 1) THEN NULL
        ELSE generated_at + INTERVAL '2 minutes'
    END
FROM (
    SELECT
        n,
        TIMESTAMPTZ '2026-01-01'
            + (RANDOM() * INTERVAL '300 days') AS generated_at
    FROM generate_series(1, 100000) AS n
) AS generated;


-- 4. Set completion dates
UPDATE banking.transfers
SET completed_at = created_at + INTERVAL '2 minutes'
WHERE transfer_id BETWEEN 2000001 AND 2100000
  AND status = 'COMPLETED';


-- 5. Generate debit ledger entries
INSERT INTO banking.ledger_entries (
    entry_id,
    transfer_id,
    account_id,
    direction,
    amount,
    created_at
)
OVERRIDING SYSTEM VALUE
SELECT
    3000000 + (transfer_id - 2000000) * 2 - 1,
    transfer_id,
    source_account_id,
    'DEBIT',
    amount,
    created_at
FROM banking.transfers
WHERE transfer_id BETWEEN 2000001 AND 2100000
  AND status = 'COMPLETED';


-- 6. Generate credit ledger entries
INSERT INTO banking.ledger_entries (
    entry_id,
    transfer_id,
    account_id,
    direction,
    amount,
    created_at
)
OVERRIDING SYSTEM VALUE
SELECT
    3000000 + (transfer_id - 2000000) * 2,
    transfer_id,
    destination_account_id,
    'CREDIT',
    amount,
    created_at
FROM banking.transfers
WHERE transfer_id BETWEEN 2000001 AND 2100000
  AND status = 'COMPLETED';

COMMIT;


-- Update PostgreSQL statistics
ANALYZE banking.customers;
ANALYZE banking.accounts;
ANALYZE banking.transfers;
ANALYZE banking.ledger_entries;