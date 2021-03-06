DROP TABLE IF EXISTS `article_reviews`;
CREATE TABLE `article_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `comments` text,
  `display` int(1) DEFAULT '1',
  `display_email_address` int(1) DEFAULT '0',
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pagetype` varchar(15) NOT NULL DEFAULT 'article',
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `product_reviews`;
CREATE TABLE `product_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `comments` text,
  `display` int(1) DEFAULT '1',
  `display_email_address` int(1) DEFAULT '0',
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pagetype` varchar(15) NOT NULL DEFAULT 'article',
   PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `feedback_new`;
CREATE TABLE `feedback_new` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comments` text,
  `display` int(1) DEFAULT '1',
  `display_email_address` int(1) DEFAULT '0',
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pagetype` varchar(15) NOT NULL DEFAULT 'article',
   PRIMARY KEY (`id`)
);

