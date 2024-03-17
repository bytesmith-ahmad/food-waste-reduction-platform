WITH Params AS (
    SELECT ? AS user_id
)
SELECT item_id,
       item_name,
       quantity,
       location,
       expiration_date,
       flagged,
       discount,
       CASE
           WHEN (flagged = 1 OR expiration_date <= NOW() + INTERVAL 7 DAY) THEN discount
           ELSE NULL
       END AS applied_discount
FROM inventory
WHERE retailer_id = (SELECT user_id FROM Params);
