-- NEED TO PROVIDE USER ID AND USER LOCATION

WITH Params AS (
    SELECT ? AS user_id,
           ? AS loc
)
SELECT i.id AS item_id,
       i.retailer_id AS retailer_id,
       i.item_name,
       "$$$" as price,
       CASE
           WHEN i.flagged = 1 OR i.expiration_date <= NOW() + INTERVAL 7 DAY THEN i.discount
           ELSE NULL
       END AS applied_discount,
       CASE
           WHEN s.user_id IS NOT NULL THEN 'subscribed'
           ELSE NULL
       END AS subscription_status
FROM inventory i
LEFT JOIN (
    SELECT DISTINCT item_id, user_id
    FROM subscriptions
) s ON i.id = s.item_id AND s.user_id = (SELECT user_id FROM Params)
WHERE
i.location = (SELECT loc FROM Params) AND
i.discount < 100;
