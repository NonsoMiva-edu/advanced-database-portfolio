-- Verify that all four tables exist
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'banking'
AND table_type = 'BASE TABLE'
ORDER BY table_name;


-- Verify customer records
SELECT * FROM banking.customers;


-- Verify account records
SELECT * FROM banking.accounts;


-- Verify transfer records
SELECT * FROM banking.transfers;


-- Verify ledger entries
SELECT * FROM banking.ledger_entries;


-- Verify the number of records in each table
SELECT 'Customers' AS entity, COUNT(*) 
FROM banking.customers

UNION ALL

SELECT 'Accounts', COUNT(*) 
FROM banking.accounts

UNION ALL

SELECT 'Transfers', COUNT(*) 
FROM banking.transfers

UNION ALL

SELECT 'Ledger Entries', COUNT(*) 
FROM banking.ledger_entries;


-- Verify that each transfer is balanced
SELECT
    transfer_id,
    SUM(
        CASE
            WHEN direction = 'CREDIT' THEN amount
            ELSE -amount
        END
    ) AS net_amount
FROM banking.ledger_entries
GROUP BY transfer_id
ORDER BY transfer_id;
