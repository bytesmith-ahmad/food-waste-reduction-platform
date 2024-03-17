START TRANSACTION;

-- Insert the purchased food item into the purchased_items table
INSERT INTO purchased_items (consumer_id, inventory_id, discount_rate) VALUES (consumer_id_value, inventory_id_value, discount_rate_value);

-- Update the retailer's inventory to decrement the quantity of the purchased food item
UPDATE inventory SET quantity = quantity - 1 WHERE inventory_id = inventory_id_value;

COMMIT;
