CREATE VIEW inventory_view AS
SELECT *,
       CASE
           WHEN flagged = 1 OR DATEDIFF(expiration_date, CURDATE()) <= 7 THEN discount
           ELSE 0
       END AS applied_discount
FROM inventory;
