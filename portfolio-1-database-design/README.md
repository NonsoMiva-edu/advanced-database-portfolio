# Portfolio 1 — Database Design and Modelling

## Scenario
NovaBank is a fictional digital bank. Customers own accounts and initiate internal transfers. Each completed transfer is represented by debit and credit ledger entries.

## Run
Run `psql -U postgres -d novabank -f schema.sql` after creating the `novabank` database. Or run the SQL in pgAdmin/DBeaver against the selected database.

## Design choices
- Customers to accounts: one-to-many.
- Accounts to transfers: each transfer references a source and destination account.
- Transfers to ledger entries: one-to-many; a completed transfer should produce a balanced debit/credit pair.
- Financial amounts use `NUMERIC(19,2)` rather than floating-point types.
- `idempotency_key` prevents duplicate transfer requests at the database level.
- Customer identity, account details, transfer metadata, and ledger records are stored separately to reduce redundancy and update anomalies (3NF-oriented design).

## Important boundaries
This is a starter schema, not a production-ready banking ledger. The schema alone does not enforce balanced entries, currency matching, sufficient funds, or immutable ledger records. These require additional transactional logic and/or triggers and tests in Portfolio 3. Never claim these guarantees are already implemented.

## Evidence to capture
1. Successful schema execution in PostgreSQL.
2. Table definitions, PK/FK relationships, and constraints in pgAdmin or DBeaver.
3. An ER diagram derived from the schema.
4. Your own explanation of 1NF, 2NF, 3NF and the tradeoffs.
