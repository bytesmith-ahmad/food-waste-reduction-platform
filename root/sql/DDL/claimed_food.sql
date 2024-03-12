CREATE TABLE claimed_food (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    charitable_org_id INT NOT NULL,
    inventory_id INT NOT NULL,
    claim_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (charitable_org_id) REFERENCES users(id),
    FOREIGN KEY (inventory_id) REFERENCES inventory(id)
);