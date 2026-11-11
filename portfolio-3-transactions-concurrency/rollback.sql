-- Check current status
SELECT account_id, status
FROM banking.accounts
WHERE account_id = 1000001;

BEGIN;

-- Temporarily change the status
UPDATE banking.accounts
SET status = 'ACTIVE'
WHERE account_id = 1000001;

-- Check status inside transaction
SELECT account_id, status
FROM banking.accounts
WHERE account_id = 1000001;

-- Undo the change
ROLLBACK;

-- Confirm original status was restored
SELECT account_id, status
FROM banking.accounts
WHERE account_id = 1000001;