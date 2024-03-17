CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    communication_method ENUM('email', 'phone') NOT NULL,
    food_preferences VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);