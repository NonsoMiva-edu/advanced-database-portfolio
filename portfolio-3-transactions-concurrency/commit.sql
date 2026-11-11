-- Check the account's current status
SELECT account_id, status
FROM banking.accounts
WHERE account_id = 1000001;

-- Start transaction
BEGIN;

UPDATE banking.accounts
SET status = 'FROZEN'
WHERE account_id = 1000001;

-- Save the change permanently
COMMIT;

-- Verify the committed change
SELECT account_id, status
FROM banking.accounts
WHERE account_id = 1000001;