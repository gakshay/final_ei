--
-- Table structure for table `jos_colors`
--
DROP TABLE IF EXISTS `jos_colors`;
CREATE TABLE IF NOT EXISTS `jos_colors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `color` varchar(100) NOT NULL DEFAULT '',
  `subcategory_id` int(11) not NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `jos_color_products`
--
DROP TABLE IF EXISTS `jos_color_products`;
CREATE TABLE IF NOT EXISTS `jos_color_products` (
  `color_id` int(11) NOT NULL DEFAULT 0,
  `product_id` int(11) not NULL DEFAULT 0
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


