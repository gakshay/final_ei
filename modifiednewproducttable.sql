
DROP TABLE IF EXISTS `new_products`;

CREATE TABLE `new_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(25) NOT NULL DEFAULT '',
  `title` varchar(255) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `price` decimal(8,2)  DEFAULT '0.00',
  `image_path` varchar(255) DEFAULT NULL,
  `prod_height` decimal(8,2) DEFAULT NULL,
  `prod_width` decimal(8,2) DEFAULT NULL,
  `prod_length` decimal(8,2) DEFAULT NULL,
  `length_unit` varchar(20) DEFAULT NULL,
  `dimension` varchar(100) DEFAULT NULL,
  `prod_weight` decimal(8,2) DEFAULT NULL,
  `weight_unit` varchar(20) DEFAULT NULL,
  `weight_to_show` varchar(100) DEFAULT NULL,
  `brief_comments` text,
  `material` text,
  `frame` varchar(255) NOT NULL DEFAULT '0',
  `availability` varchar(20) DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT '0',
  `sold` varchar(15) DEFAULT '0',
  `specialbuyer` tinyint(1) NOT NULL DEFAULT '0',
  `date_added` date,
  `transid` text,
  `coltime` timestamp  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isbn` varchar(255) DEFAULT NULL,
  `author` text,
  `publisher` varchar(200) DEFAULT NULL,
  `description` text,
  `pages` text,
  `cover_type` varchar(200) DEFAULT NULL,
  `edition` mediumint(9) DEFAULT NULL,
  `time` varchar(200) DEFAULT '0',
   PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `previous_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
   PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `subcategories`;
CREATE TABLE `subcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `previous_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
   PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `new_products_subcategories`;
CREATE TABLE `new_products_subcategories` (
  `new_product_id` int(11) NOT NULL,
  `subcategory_id` int(11) NOT NULL
);
