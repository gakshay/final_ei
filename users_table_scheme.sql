DROP TABLE IF EXISTS `mansur`.`users`;

CREATE  TABLE `mansur`.`users` (
	`id` INT(11) NOT NULL AUTO_INCREMENT ,
	`login` VARCHAR(80) NOT NULL DEFAULT "" ,
	`email` VARCHAR(200) NULL DEFAULT NULL ,
	`discount` DECIMAL(5,2) NULL DEFAULT '0.00',
	`registered` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`buy`	TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`wholesaler` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`specialbuyer` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`firsttime` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`bulk` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`threshold` INT(5) NULL DEFAULT '0',
	`dateofexpiry` DATE NULL DEFAULT '2004-01-05',
	`items_of_interest` TEXT NULL DEFAULT NULL ,
	`requirements` TEXT NULL DEFAULT NULL ,
	`comments` TEXT NULL DEFAULT NULL ,
	`volume` VARCHAR(100) NULL DEFAULT NULL ,
	`credit` DECIMAL(10,2) NOT NULL DEFAULT '0.00' ,
	`coltime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`) );

DROP TABLE IF EXISTS `mansur`.`user_address`;

CREATE  TABLE `mansur`.`user_address` (
	`id` INT(11) NOT NULL AUTO_INCREMENT ,
        `user_id` INT(11) NOT NULL,
	`userid` VARCHAR(200) NOT NULL DEFAULT "" ,
	`first_name` VARCHAR(50) NULL DEFAULT NULL ,
	`last_name` VARCHAR(50) NULL DEFAULT NULL ,
	`company` VARCHAR(255) NULL DEFAULT NULL ,
	`address1` TEXT NULL DEFAULT NULL ,
	`city` VARCHAR(100) NULL DEFAULT NULL ,
	`state` VARCHAR(100) NULL DEFAULT NULL ,
	`zip` VARCHAR(50) NULL DEFAULT NULL ,
	`country` VARCHAR(200) NULL DEFAULT NULL ,
	`phone` VARCHAR(50) NULL DEFAULT NULL ,
	`fax` VARCHAR(50) NULL DEFAULT NULL ,
	`ship_to_first_name` VARCHAR(50) NULL DEFAULT NULL ,
	`ship_to_last_name` VARCHAR(50) NULL DEFAULT NULL ,
	`ship_to_company` VARCHAR(255) NULL DEFAULT NULL ,
	`ship_to_address1` TEXT NULL DEFAULT NULL ,
	`ship_to_city` VARCHAR(100) NULL DEFAULT NULL ,
	`ship_to_state` VARCHAR(100) NULL DEFAULT NULL ,
	`ship_to_zip` VARCHAR(50) NULL DEFAULT NULL ,
	`ship_to_country` VARCHAR(200) NULL DEFAULT NULL ,
	`ship_to_phone` VARCHAR(50) NULL DEFAULT NULL ,
	`ship_to_fax` VARCHAR(50) NULL DEFAULT NULL ,
	`ship_to_email` VARCHAR(200) NULL DEFAULT NULL ,
	`ship_to_address2` TEXT NULL DEFAULT NULL ,
	`address2` TEXT NULL DEFAULT NULL ,
	`checkout` VARCHAR(8) NOT NULL DEFAULT 'online' ,
	`carddet` VARCHAR(30) NOT NULL DEFAULT '-' ,
	`coltime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	 PRIMARY KEY (`id`) );
