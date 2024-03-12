CREATE TABLE purchased_items (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    consumer_id INT NOT NULL,
    inventory_id INT NOT NULL,
    discount_rate INT DEFAULT 0 CHECK (discount_rate >= 0 AND discount_rate <= 100),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consumer_id) REFERENCES users(id),
    FOREIGN KEY (inventory_id) REFERENCES inventory(id)
);