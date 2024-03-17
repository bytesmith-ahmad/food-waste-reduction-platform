START TRANSACTION;

-- Deduct funds from sender's account
UPDATE accounts SET balance = balance - ? WHERE account_id = ?;

-- Add funds to receiver's account
UPDATE accounts SET balance = balance + ? WHERE account_id = ?;

COMMIT;
