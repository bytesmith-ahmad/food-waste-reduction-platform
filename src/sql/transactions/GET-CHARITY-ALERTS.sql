-- PARAMETERS: user_id, communication_method
-- Fetch all items which are discounted 100% and flagged by charitable organization

SELECT 
    inventory.id AS item_id, 
    inventory.item_name, 
    inventory.discount 
FROM 
    inventory 
JOIN 
    subscriptions ON inventory.id = subscriptions.item_id
JOIN 
    users ON subscriptions.user_id = ?
WHERE 
    inventory.discount = 100
    AND users.communication_method = ?;
