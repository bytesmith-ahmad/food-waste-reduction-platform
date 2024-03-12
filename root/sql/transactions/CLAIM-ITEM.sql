START TRANSACTION;

-- Insert the claimed food item into the claimed_food table
INSERT INTO claimed_food (charitable_org_id, inventory_id) VALUES (?,?);

-- Update the retailer's inventory to decrement the quantity of the claimed food item
UPDATE inventory SET quantity = quantity - 1 WHERE inventory_id = ?;

COMMIT;
