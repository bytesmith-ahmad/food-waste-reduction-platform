CREATE TABLE inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    retail_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    expiration_date DATE,
    flagged BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (retail_id) REFERENCES users(id)
);