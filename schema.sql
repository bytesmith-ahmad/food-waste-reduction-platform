-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema fwrp
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema fwrp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fwrp` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `fwrp` ;

-- -----------------------------------------------------
-- Table `fwrp`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `user_type` ENUM('retailer', 'consumer', 'charitable_organization') NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`inventory` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `retail_id` INT NOT NULL,
  `item_name` VARCHAR(255) NOT NULL,
  `quantity` INT NOT NULL,
  `expiration_date` DATE NULL DEFAULT NULL,
  `flagged_surplus` TINYINT(1) NULL DEFAULT '0',
  `flagged_donation` TINYINT(1) NULL DEFAULT NULL,
  `price` DOUBLE NOT NULL,
  `discount` DOUBLE NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `retail_id` (`retail_id` ASC) VISIBLE,
  CONSTRAINT `inventory_ibfk_1`
    FOREIGN KEY (`retail_id`)
    REFERENCES `fwrp`.`users` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`claimed_food`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`claimed_food` (
  `claim_id` INT NOT NULL AUTO_INCREMENT,
  `charitable_org_id` INT NOT NULL,
  `inventory_id` INT NOT NULL,
  `claim_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`claim_id`),
  INDEX `charitable_org_id` (`charitable_org_id` ASC) VISIBLE,
  INDEX `inventory_id` (`inventory_id` ASC) VISIBLE,
  CONSTRAINT `claimed_food_ibfk_1`
    FOREIGN KEY (`charitable_org_id`)
    REFERENCES `fwrp`.`users` (`id`),
  CONSTRAINT `claimed_food_ibfk_2`
    FOREIGN KEY (`inventory_id`)
    REFERENCES `fwrp`.`inventory` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`invoices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`invoices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `inventory_id` INT NOT NULL,
  `transaction_type` ENUM('purchase', 'donation') NOT NULL,
  `transaction_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `discount_rate` INT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `inventory_id` (`inventory_id` ASC) VISIBLE,
  CONSTRAINT `invoices_ibfk_2`
    FOREIGN KEY (`inventory_id`)
    REFERENCES `fwrp`.`inventory` (`id`),
  CONSTRAINT `users_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `fwrp`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`logins`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`logins` (
  `user_id` INT NOT NULL,
  `session_token` VARCHAR(255) NOT NULL,
  `login_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `logins_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `fwrp`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`purchased_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`purchased_items` (
  `purchase_id` INT NOT NULL AUTO_INCREMENT,
  `consumer_id` INT NOT NULL,
  `inventory_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `purchase_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`purchase_id`),
  INDEX `consumer_id` (`consumer_id` ASC) VISIBLE,
  INDEX `inventory_id` (`inventory_id` ASC) VISIBLE,
  CONSTRAINT `purchased_items_ibfk_1`
    FOREIGN KEY (`consumer_id`)
    REFERENCES `fwrp`.`users` (`id`),
  CONSTRAINT `purchased_items_ibfk_2`
    FOREIGN KEY (`inventory_id`)
    REFERENCES `fwrp`.`inventory` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`subscriptions` (
  `subscription_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `communication_method` ENUM('email', 'phone') NOT NULL,
  `minPrice` DOUBLE NULL DEFAULT '0',
  `maxPrice` DOUBLE NULL DEFAULT '2147483647',
  `minQty` INT NULL DEFAULT '0',
  `maxQty` INT NULL DEFAULT '2147483647',
  `subscription_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`subscription_id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `subscriptions_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `fwrp`.`users` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `fwrp` ;

-- -----------------------------------------------------
-- Placeholder table for view `fwrp`.`inventory_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fwrp`.`inventory_view` (`id` INT, `retail_id` INT, `item_name` INT, `quantity` INT, `expiration_date` INT, `flagged_surplus` INT, `flagged_donation` INT, `price` INT, `discount` INT, `applied_discount` INT);

-- -----------------------------------------------------
-- View `fwrp`.`inventory_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fwrp`.`inventory_view`;
USE `fwrp`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `fwrp`.`inventory_view` AS select `fwrp`.`inventory`.`id` AS `id`,`fwrp`.`inventory`.`retail_id` AS `retail_id`,`fwrp`.`inventory`.`item_name` AS `item_name`,`fwrp`.`inventory`.`quantity` AS `quantity`,`fwrp`.`inventory`.`expiration_date` AS `expiration_date`,`fwrp`.`inventory`.`flagged_surplus` AS `flagged_surplus`,`fwrp`.`inventory`.`flagged_donation` AS `flagged_donation`,`fwrp`.`inventory`.`price` AS `price`,`fwrp`.`inventory`.`discount` AS `discount`,(case when ((`fwrp`.`inventory`.`flagged_surplus` = 1) or ((to_days(`fwrp`.`inventory`.`expiration_date`) - to_days(curdate())) <= 7)) then `fwrp`.`inventory`.`discount` else 0 end) AS `applied_discount` from `fwrp`.`inventory` where (`fwrp`.`inventory`.`id` in (select `fwrp`.`claimed_food`.`inventory_id` from `fwrp`.`claimed_food`) is false and (`fwrp`.`inventory`.`quantity` > 0));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
