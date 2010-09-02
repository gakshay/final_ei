--
-- Table structure for table `jos_vm_product_type`
--
DROP TABLE IF EXISTS `jos_vm_product_type`;
CREATE TABLE IF NOT EXISTS `jos_vm_product_type` (
  `product_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_type_name` varchar(255) NOT NULL DEFAULT '',
  `product_type_description` text,
  `product_type_publish` char(1) DEFAULT NULL,
  `product_type_browsepage` varchar(255) DEFAULT NULL,
  `product_type_flypage` varchar(255) DEFAULT NULL,
  `product_type_list_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `jos_vm_product_type`
--

INSERT INTO `jos_vm_product_type` (`product_type_id`, `product_type_name`, `product_type_description`, `product_type_publish`, `product_type_browsepage`, `product_type_flypage`, `product_type_list_order`) VALUES
(3, 'meta', 'meta', 'Y', '', '', 3);

--
-- Table structure for table `jos_product_type_3`
--
DROP TABLE IF EXISTS `jos_vm_product_type_3`;
CREATE TABLE IF NOT EXISTS `jos_vm_product_type_3` (
  `product_id` int(11) NOT NULL,
  `metadata` text,
  `dimension` text,
  `material` text,
  `specialbuyer` text,
  `isbn` text,
  `author` text,
  `publisher` text,
  `pages` text,
  `cover_type` text,
  `edition` text,
  `description` text,
  PRIMARY KEY (`product_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


--
-- Table structure for table `jos_vm_product_product_type_xref`
--
DROP TABLE IF EXISTS `jos_vm_product_product_type_xref`;
CREATE TABLE IF NOT EXISTS `jos_vm_product_product_type_xref` (
  `product_id` int(11) NOT NULL DEFAULT '0',
  `product_type_id` int(11) NOT NULL DEFAULT '0',
  KEY `idx_product_product_type_xref_product_id` (`product_id`),
  KEY `idx_product_product_type_xref_product_type_id` (`product_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maps products to a product type';


--
-- Table structure for table `jos_vm_product_type_parameter`
--
DROP TABLE IF EXISTS `jos_vm_product_type_parameter`;
CREATE TABLE IF NOT EXISTS `jos_vm_product_type_parameter` (
  `product_type_id` int(11) NOT NULL DEFAULT '0',
  `parameter_name` varchar(255) NOT NULL DEFAULT '',
  `parameter_label` varchar(255) NOT NULL DEFAULT '',
  `parameter_description` text,
  `parameter_list_order` int(11) NOT NULL DEFAULT '0',
  `parameter_type` char(1) NOT NULL DEFAULT 'T',
  `parameter_values` varchar(255) DEFAULT NULL,
  `parameter_multiselect` char(1) DEFAULT NULL,
  `parameter_default` varchar(255) DEFAULT NULL,
  `parameter_unit` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`product_type_id`,`parameter_name`),
  KEY `idx_product_type_parameter_product_type_id` (`product_type_id`),
  KEY `idx_product_type_parameter_parameter_order` (`parameter_list_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Parameters which are part of a product type';

--
-- Dumping data for table `jos_vm_product_type_parameter`
--

INSERT INTO `jos_vm_product_type_parameter` (`product_type_id`, `parameter_name`, `parameter_label`, `parameter_description`, `parameter_list_order`, `parameter_type`, `parameter_values`, `parameter_multiselect`, `parameter_default`, `parameter_unit`) VALUES
(3, 'dimension', 'dimension', '', 2, 'T', '', 'N', '', ''),
(3, 'metadata', 'metadata', '', 1, 'T', '', 'N', '', ''),
(3, 'material', 'material', '', 3, 'T', '', 'N', '', ''),
(3, 'specialbuyer', 'specialbuyer', '', 4, 'T', '', 'N', '', ''),
(3, 'isbn', 'isbn', '', 5, 'T', '', 'N', '', ''),
(3, 'author', 'author', '', 6, 'T', '', 'N', '', ''),
(3, 'publisher', 'publisher', '', 7, 'T', '', 'N', '', ''),
(3, 'pages', 'pages', '', 8, 'T', '', 'N', '', ''),
(3, 'cover_type', 'cover_type', '', 9, 'T', '', 'N', '', ''),
(3, 'edition', 'edition', '', 10, 'T', '', 'N', '', ''),
(3, 'description', 'description', '', 11, 'T', '', 'N', '', '');


--
-- Table structure for table `jos_content`
--
DROP TABLE IF EXISTS `jos_content`;
CREATE TABLE IF NOT EXISTS `jos_content` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `alias` varchar(255) NOT NULL default '',
  `title_alias` varchar(255) NOT NULL default '',
  `introtext` mediumtext NOT NULL,
  `fulltext` mediumtext NOT NULL,
  `state` tinyint(3) NOT NULL default '0',
  `sectionid` int(11) unsigned NOT NULL default '0',
  `mask` int(11) unsigned NOT NULL default '0',
  `catid` int(11) unsigned NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL default '0',
  `created_by_alias` varchar(255) NOT NULL default '',
  `modified` datetime default '0000-00-00 00:00:00',
  `modified_by` int(11) unsigned NOT NULL default '0',
  `checked_out` int(11) unsigned NOT NULL default '0',
  `checked_out_time` datetime default '0000-00-00 00:00:00',
  `publish_up` datetime default '0000-00-00 00:00:00',
  `publish_down` datetime default '0000-00-00 00:00:00',
  `images` text NOT NULL,
  `urls` text NOT NULL,
  `attribs` text NOT NULL,
  `version` int(11) unsigned NOT NULL default '1',
  `parentid` int(11) unsigned NOT NULL default '0',
  `ordering` int(11) NOT NULL default '0',
  `metakey` text NOT NULL,
  `metadesc` text NOT NULL,
  `access` int(11) unsigned NOT NULL default '0',
  `hits` int(11) unsigned NOT NULL default '0',
  `metadata` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `idx_section` (`sectionid`),
  KEY `idx_access` (`access`),
  KEY `idx_checkout` (`checked_out`),
  KEY `idx_state` (`state`),
  KEY `idx_catid` (`catid`),
  KEY `idx_createdby` (`created_by`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `jos_webeeComment_Comment`
--
DROP TABLE IF EXISTS `jos_webeeComment_Comment`;
CREATE TABLE IF NOT EXISTS `jos_webeeComment_Comment` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `articleId` int(10) unsigned NOT NULL default '0',
  `content` text NOT NULL,
  `handle` text NOT NULL,
  `isUser` int(10) unsigned NOT NULL default '0',
  `email` text NOT NULL,
  `url` text,
  `published` int(10) unsigned NOT NULL default '0',
  `saved` datetime default '0000-00-00 00:00:00',
  `ordering` int(10) unsigned NOT NULL default '0',
  `hits` int(10) unsigned NOT NULL default '0',
  `ipAddress` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

