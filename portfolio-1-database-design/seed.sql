-- ==========================================
-- NOVABANK - PORTFOLIO 1 SEED DATA
-- ==========================================

-- 1. CUSTOMERS
INSERT INTO banking.customers (full_name, email)
VALUES
('Ada Okafor', 'ada@novabank.test'),
('Tunde Bello', 'tunde@novabank.test'),
('Chiamaka Eze', 'chiamaka@novabank.test'),
('David Johnson', 'david@novabank.test');


-- 2. ACCOUNTS
INSERT INTO banking.accounts (
    customer_id,
    account_number,
    currency
)
VALUES
(1, '1000000001', 'NGN'),
(2, '1000000002', 'NGN'),
(3, '1000000003', 'NGN'),
(4, '1000000004', 'NGN');


-- 3. TRANSFERS
INSERT INTO banking.transfers (
    idempotency_key,
    source_account_id,
    destination_account_id,
    amount,
    currency,
    status,
    completed_at
)
VALUES
(
    '00000000-0000-4000-8000-000000000001',
    1, 2, 15000.00, 'NGN', 'COMPLETED', NOW()
),
(
    '00000000-0000-4000-8000-000000000002',
    2, 3, 5000.00, 'NGN', 'COMPLETED', NOW()
),
(
    '00000000-0000-4000-8000-000000000003',
    3, 4, 2500.00, 'NGN', 'COMPLETED', NOW()
);


-- 4. LEDGER ENTRIES
INSERT INTO banking.ledger_entries (
    transfer_id,
    account_id,
    direction,
    amount
)
VALUES
-- Transfer 1: Ada -> Tunde
(1, 1, 'DEBIT', 15000.00),
(1, 2, 'CREDIT', 15000.00),

-- Transfer 2: Tunde -> Chiamaka
(2, 2, 'DEBIT', 5000.00),
(2, 3, 'CREDIT', 5000.00),

-- Transfer 3: Chiamaka -> David
(3, 3, 'DEBIT', 2500.00),
(3, 4, 'CREDIT', 2500.00);
