CREATE SCHEMA IF NOT EXISTS banking;
CREATE TABLE banking.customers (
 customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(255) NOT NULL UNIQUE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE banking.accounts (
 account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 customer_id BIGINT NOT NULL REFERENCES banking.customers(customer_id),
 account_number VARCHAR(20) NOT NULL UNIQUE,
 currency CHAR(3) NOT NULL DEFAULT 'NGN',
 status VARCHAR(12) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','FROZEN','CLOSED')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE banking.transfers (
 transfer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 idempotency_key UUID NOT NULL UNIQUE,
 source_account_id BIGINT NOT NULL REFERENCES banking.accounts(account_id),
 destination_account_id BIGINT NOT NULL REFERENCES banking.accounts(account_id),
 amount NUMERIC(19,2) NOT NULL CHECK (amount > 0),
 currency CHAR(3) NOT NULL,
 status VARCHAR(12) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','COMPLETED','FAILED')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 completed_at TIMESTAMPTZ,
 CHECK (source_account_id <> destination_account_id),
 CHECK ((status = 'COMPLETED' AND completed_at IS NOT NULL) OR (status <> 'COMPLETED' AND completed_at IS NULL))
);
CREATE TABLE banking.ledger_entries (
 entry_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 transfer_id BIGINT NOT NULL REFERENCES banking.transfers(transfer_id),
 account_id BIGINT NOT NULL REFERENCES banking.accounts(account_id),
 direction VARCHAR(6) NOT NULL CHECK (direction IN ('DEBIT','CREDIT')),
 amount NUMERIC(19,2) NOT NULL CHECK (amount > 0),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 UNIQUE (transfer_id, account_id, direction)
);
CREATE INDEX ix_accounts_customer ON banking.accounts(customer_id);
CREATE INDEX ix_transfers_source_created ON banking.transfers(source_account_id, created_at DESC);
CREATE INDEX ix_ledger_account_created ON banking.ledger_entries(account_id, created_at DESC);
COMMENT ON TABLE banking.ledger_entries IS 'Ledger records are intended to be append-only; enforce immutability and balanced posting in transaction service or database triggers.';
