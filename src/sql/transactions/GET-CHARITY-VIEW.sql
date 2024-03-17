WITH Params AS (
    SELECT ? AS loc
)
SELECT i.id AS item_id,
       u.name AS retailer_name,
       i.item_name,
       CASE
           WHEN s.user_id IS NOT NULL THEN 'true'
           ELSE 'false'
       END AS subscribed
FROM inventory i
JOIN users u ON i.retailer_id = u.id
LEFT JOIN subscriptions s ON i.id = s.item_id
WHERE i.location = (SELECT loc FROM Params)
  AND i.discount = 100;
