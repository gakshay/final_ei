-- MySQL dump 10.13  Distrib 5.1.37, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: mansur
-- ------------------------------------------------------
-- Server version	5.1.37-1ubuntu5.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `article_reviews`
--

DROP TABLE IF EXISTS `article_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `comments` text,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `display_name` int(1) DEFAULT '1',
  `display_email_address` int(1) DEFAULT '0',
  `date_added` date DEFAULT NULL,
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pagetype` varchar(15) NOT NULL DEFAULT 'article',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articlelinks_new`
--

DROP TABLE IF EXISTS `articlelinks_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articlelinks_new` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `article_id` int(5) NOT NULL,
  `linktype` varchar(1) NOT NULL DEFAULT 'X',
  `url` text,
  `image` varchar(45) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `writeup` text,
  `display` tinyint(1) NOT NULL DEFAULT '1',
  `name` varchar(200) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articles_new`
--

DROP TABLE IF EXISTS `articles_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles_new` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `URL` varchar(200) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `content` longtext,
  `editor` text,
  `date_added` date DEFAULT NULL,
  `keywords` text,
  `description` text,
  `indexpage` text,
  `iconname` varchar(100) DEFAULT NULL,
  `maxicons` int(3) NOT NULL DEFAULT '25',
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ticker` int(9) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `previous_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feedback_new`
--

DROP TABLE IF EXISTS `feedback_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback_new` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comments` text,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `display_name` int(1) DEFAULT '1',
  `display_email_address` int(1) DEFAULT '0',
  `date_added` date DEFAULT NULL,
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pagetype` varchar(15) NOT NULL DEFAULT 'article',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_attr`
--

DROP TABLE IF EXISTS `product_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_attr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `label` varchar(45) NOT NULL,
  `value` varchar(45) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_reviews`
--

DROP TABLE IF EXISTS `product_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `comments` text,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `display_name` int(1) DEFAULT '1',
  `display_email_address` int(1) DEFAULT '0',
  `date_added` date DEFAULT NULL,
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pagetype` varchar(15) NOT NULL DEFAULT 'article',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_products`
--

DROP TABLE IF EXISTS `new_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(25) NOT NULL DEFAULT '',
  `title` varchar(255) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `price` decimal(8,2) DEFAULT '0.00',
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
  `keyword` text,
  `material` text,
  `frame` varchar(255) NOT NULL DEFAULT '0',
  `availability` varchar(20) DEFAULT NULL,
  `archive` tinyint(1) DEFAULT '0',
  `sold` varchar(15) DEFAULT '0',
  `specialbuyer` tinyint(1) NOT NULL DEFAULT '0',
  `date_added` date DEFAULT NULL,
  `transid` text,
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isbn` varchar(255) DEFAULT NULL,
  `author` text,
  `publisher` varchar(200) DEFAULT NULL,
  `description` text,
  `pages` text,
  `cover_type` varchar(200) DEFAULT NULL,
  `edition` mediumint(9) DEFAULT NULL,
  `time` varchar(200) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_products_subcategories`
--

DROP TABLE IF EXISTS `new_products_subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_products_subcategories` (
  `new_product_id` int(11) NOT NULL,
  `subcategory_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `specialbrowse_links_new`
--

DROP TABLE IF EXISTS `specialbrowse_links_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specialbrowse_links_new` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `filename` varchar(200) NOT NULL DEFAULT '',
  `subcategory_id` int(11) NOT NULL,
  `dropdownonly` tinyint(1) NOT NULL DEFAULT '0',
  `artists` text,
  `iscolor` int(1) NOT NULL DEFAULT '0',
  `available` tinyint(1) NOT NULL DEFAULT '0',
  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `keyword` text,
  `description` text,
  `titletag` varchar(255) DEFAULT NULL,
  `buttontext` varchar(50) NOT NULL DEFAULT '',
  `buttoncolor` varchar(50) NOT NULL DEFAULT '',
  `specials_nocat` varchar(255) DEFAULT NULL,
  `specials_mustorcat` varchar(255) DEFAULT NULL,
  `specials_mustandcat` varchar(255) DEFAULT NULL,
  `specials_wt` varchar(100) DEFAULT NULL,
  `specials_exclflds` varchar(255) DEFAULT NULL,
  `specials_modifier` varchar(10) DEFAULT NULL,
  `specials_extra_words` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subcategories`
--

DROP TABLE IF EXISTS `subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subcategories_attribute_labels`
--

DROP TABLE IF EXISTS `subcategories_attribute_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subcategories_attribute_labels` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `subcategory_id` int(4) NOT NULL,
  `label1` varchar(100) DEFAULT NULL,
  `label2` varchar(100) DEFAULT NULL,
  `label3` varchar(100) DEFAULT NULL,
  `label4` varchar(100) DEFAULT NULL,
  `label5` varchar(100) DEFAULT NULL,
  `label6` varchar(100) DEFAULT NULL,
  `label7` varchar(100) DEFAULT NULL,
  `label8` varchar(100) DEFAULT NULL,
  `label9` varchar(100) DEFAULT NULL,
  `label10` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subcategories_attribute_values`
--

DROP TABLE IF EXISTS `subcategories_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subcategories_attribute_values` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `subcategory_id` int(4) NOT NULL,
  `value1` varchar(100) DEFAULT NULL,
  `value2` varchar(100) DEFAULT NULL,
  `value3` varchar(100) DEFAULT NULL,
  `value4` varchar(100) DEFAULT NULL,
  `value5` varchar(100) DEFAULT NULL,
  `value6` varchar(100) DEFAULT NULL,
  `value7` varchar(100) DEFAULT NULL,
  `value8` varchar(100) DEFAULT NULL,
  `value9` varchar(100) DEFAULT NULL,
  `value10` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_address`
--

--  DROP TABLE IF EXISTS `user_address`;
--  /*!40101 SET @saved_cs_client     = @@character_set_client */;
--  /*!40101 SET character_set_client = utf8 */;
--  CREATE TABLE `user_address` (
--  `id` int(11) NOT NULL AUTO_INCREMENT,
--  `user_id` int(11) NOT NULL,
--  `userid` varchar(200) NOT NULL DEFAULT '',
--  `first_name` varchar(50) DEFAULT NULL,
--  `last_name` varchar(50) DEFAULT NULL,
--  `company` varchar(255) DEFAULT NULL,
--  `address1` text,
--  `city` varchar(100) DEFAULT NULL,
--  `state` varchar(100) DEFAULT NULL,
--  `zip` varchar(50) DEFAULT NULL,
--  `country` varchar(200) DEFAULT NULL,
--  `phone` varchar(50) DEFAULT NULL,
--  `fax` varchar(50) DEFAULT NULL,
--  `ship_to_first_name` varchar(50) DEFAULT NULL,
--  `ship_to_last_name` varchar(50) DEFAULT NULL,
--  `ship_to_company` varchar(255) DEFAULT NULL,
--  `ship_to_address1` text,
--  `ship_to_city` varchar(100) DEFAULT NULL,
--  `ship_to_state` varchar(100) DEFAULT NULL,
--  `ship_to_zip` varchar(50) DEFAULT NULL,
--  `ship_to_country` varchar(200) DEFAULT NULL,
--  `ship_to_phone` varchar(50) DEFAULT NULL,
--  `ship_to_fax` varchar(50) DEFAULT NULL,
--  `ship_to_email` varchar(200) DEFAULT NULL,
--  `ship_to_address2` text,
--  `address2` text,
--  `checkout` varchar(8) NOT NULL DEFAULT 'online',
--  `carddet` varchar(30) NOT NULL DEFAULT '-',
--  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--  PRIMARY KEY (`id`)
--  ) ENGINE=MyISAM DEFAULT CHARSET=latin1;
--  /*!40101 SET character_set_client = @saved_cs_client */;

----
---- Table structure for table `users`
----

--  DROP TABLE IF EXISTS `users`;
--  /*!40101 SET @saved_cs_client     = @@character_set_client */;
--  /*!40101 SET character_set_client = utf8 */;
--  CREATE TABLE `users` (
--  `id` int(11) NOT NULL AUTO_INCREMENT,
--  `login` varchar(80) NOT NULL DEFAULT '',
--  `email` varchar(200) DEFAULT NULL,
--  `discount` decimal(5,2) DEFAULT '0.00',
--  `registered` tinyint(3) unsigned NOT NULL DEFAULT '0',
--  `buy` tinyint(3) unsigned NOT NULL DEFAULT '0',
--  `wholesaler` tinyint(3) unsigned NOT NULL DEFAULT '0',
--  `specialbuyer` tinyint(3) unsigned NOT NULL DEFAULT '0',
--  `firsttime` tinyint(3) unsigned NOT NULL DEFAULT '0',
--  `bulk` tinyint(3) unsigned NOT NULL DEFAULT '0',
--  `threshold` int(5) DEFAULT '0',
--  `dateofexpiry` date DEFAULT '2004-01-05',
--  `items_of_interest` text,
--  `requirements` text,
--  `comments` text,
--  `volume` varchar(100) DEFAULT NULL,
--  `credit` decimal(10,2) NOT NULL DEFAULT '0.00',
--  `coltime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--  PRIMARY KEY (`id`)
--  ) ENGINE=MyISAM DEFAULT CHARSET=latin1;
--  *!40101 SET character_set_client = @saved_cs_client */;
--  /*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--  /*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
--  /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
--  /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
--  /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
--  /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
--  /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
--  /*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

---- Dump completed on 2010-07-19 16:28:06
