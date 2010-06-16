CREATE  TABLE IF NOT EXISTS `mansur`.`product_attr` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `product_id` INT NOT NULL ,
  `label` VARCHAR(45) NOT NULL ,
  `value` VARCHAR(45) NOT NULL ,
  `quantity` INT NULL ,
  `price` FLOAT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;
