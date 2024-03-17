-- MySQL Script generated by MySQL Workbench
-- Sun Mar 17 12:58:15 2024
-- Model: New Model    Version: 1.0
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
DROP TABLE IF EXISTS `fwrp`.`users` ;

CREATE TABLE IF NOT EXISTS `fwrp`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_type` ENUM('retailer', 'consumer', 'charitable_organization') NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `phone` INT NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`inventory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fwrp`.`inventory` ;

CREATE TABLE IF NOT EXISTS `fwrp`.`inventory` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `retailer_id` INT NOT NULL,
  `item_name` VARCHAR(255) NOT NULL,
  `quantity` INT NOT NULL,
  `location` VARCHAR(45) NOT NULL,
  `expiration_date` DATE NOT NULL,
  `flagged` TINYINT(1) NULL DEFAULT '0',
  `discount` INT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `retail_id` (`retailer_id` ASC) VISIBLE,
  CONSTRAINT `inventory_ibfk_1`
    FOREIGN KEY (`retailer_id`)
    REFERENCES `fwrp`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fwrp`.`invoices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fwrp`.`invoices` ;

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
DROP TABLE IF EXISTS `fwrp`.`logins` ;

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
-- Table `fwrp`.`subscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fwrp`.`subscriptions` ;

CREATE TABLE IF NOT EXISTS `fwrp`.`subscriptions` (
  `user_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `item_id` (`item_id` ASC) VISIBLE,
  CONSTRAINT `subscriptions_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `fwrp`.`users` (`id`),
  CONSTRAINT `subscriptions_ibfk_2`
    FOREIGN KEY (`item_id`)
    REFERENCES `fwrp`.`inventory` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
