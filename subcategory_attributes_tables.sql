CREATE TABLE `subcategories_attribute_values` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `subcategory_id` int(4) NOT NULL,
  `value1` varchar(100),
  `value2` varchar(100),
  `value3` varchar(100),
  `value4` varchar(100),
  `value5` varchar(100),
  `value6` varchar(100),
  `value7` varchar(100),
  `value8` varchar(100),
  `value9` varchar(100),
  `value10` varchar(100),
   PRIMARY KEY (`id`)
);

CREATE TABLE `subcategories_attribute_labels` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `subcategory_id` int(4) NOT NULL,
  `label1` varchar(100),
  `label2` varchar(100),
  `label3` varchar(100),
  `label4` varchar(100),
  `label5` varchar(100),
  `label6` varchar(100),
  `label7` varchar(100),
  `label8` varchar(100),
  `label9` varchar(100),
  `label10` varchar(100),
   PRIMARY KEY (`id`)
);

