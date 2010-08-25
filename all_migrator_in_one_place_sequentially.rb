require "rubygems"
require "exotic_migrator"
require "affiliation"

def gsub_file(path, regexp, *args, &block)
	content = File.read(path).gsub(regexp, *args, &block)
  File.open(path, 'wb') { |file| file.write(content) }
end

################################### Start of First Phase ##################################

#puts "************************** FIRST PHASE STARTING ***********************"
#puts "\n Importing new table Schema in Mansur"
#system "mysql -uroot mansur < all_new_table_scheme_that_has_to_be_created_before_running_migrator_script_in_exotic.sql"

#puts "Migrating Category..."
#Category.categories_migrator

#puts "Migrating Subcategory..."
#Subcategory.sub_categories_migrator

#puts "Firstly, Merging Books into Products..."
#NewProduct.merge_book_category

#puts "Migrating all the Products(may take 15-20min)..."
#product_migrator = ProductMigrator.new.migrating_product

#puts "Now Mapping Products with their sub category..."
#ProductMigrator.new.map_product_with_sub_category

puts "Migrating SpecialBrowseLinks(special_subcategories)..."
SpecialBrowseLink.migrate_specialbrowse

#puts "Migrating Ring sizes..."
#ProductAttr.migrate_ring_sizes

#puts "Subcategory Attribute Lables and their values..."
#SubcategoryAttributeLabel.saree_labels
#SubcategoryAttributeLabel.salwar_labels
#SubcategoryAttributeLabel.ring_labels
#SubcategoryAttributeValue.saree_values
#SubcategoryAttributeValue.salwar_values
#SubcategoryAttributeValue.ring_values

#puts "ARTICLE_FILE_PATH: #{ARTICLE_FILE_PATH}. Want to change?(Y/N)"
#choice = gets.chomp
#if choice == "Y"
#  puts "Enter Your path to articlebodies:"
#  ARTICLE_FILE_PATH = gets.chomp
#end
#puts "Migrating Articles..."
#NewArticles.migrate
#NewArticlelinks.migrate

#puts "Seperating feedback into feedback_new, article_reviews, product_reviews..."
#NewFeedBack.migrate_site_feeback
#ArticleReview.migrate_article_reviews
#ProductReview.migrate_product_reviews

#puts "migrating Affilitaions..."
#Affiliation::CreateNewAffiliate.down
#Affiliation::CreateNewAffiliate.up
#Affiliation::AffiliateNew.migrate_affiliate

#puts "************************* END OF FIRST PHASE ***************************"

#################################### SECOND PHASE OF AUTOMATION ##################################

#puts "\n************************** SECOND PHASE STARTING ***********************"
#require "exotic_products_special_subcategories"

#time = Date.today.to_s.gsub(/-/,"")+Time.now.to_i.to_s

#puts "Dumping Mansur Database (relevant tables) to /tmp/mansur_dump_#{time}.sql..."
#system "mysqldump -uroot --database mansur --tables articlelinks_new article_reviews articles_new categories feedback_new framing new_products product_attr product_reviews new_products_subcategories specialbrowse_links_new  subcategories subcategories_attribute_labels subcategories_attribute_values affdetails affiliate_new affpayments  affsales shoplogs shopcart shoppingdetails itemsbought > /tmp/mansur_dump_#{time}.sql"

#puts "Changing DB engine, CHARSET and name of Product tables..."
#gsub_file("/tmp/mansur_dump_#{time}.sql",/ENGINE=MyISAM/, "ENGINE=InnoDB")
#gsub_file("/tmp/mansur_dump_#{time}.sql",/CHARSET=latin1/, "CHARSET=utf8")
#gsub_file("/tmp/mansur_dump_#{time}.sql",/`new_products`/, "`product`")
#gsub_file("/tmp/mansur_dump_#{time}.sql",/`new_products_subcategories`/, "`product_subcategories`")
#gsub_file("/tmp/mansur_dump_#{time}.sql",/`new_product_id`/, "`product_id`")

#puts "Creating new DATABASE clearsenses_v2 ..."
#system "mysqldump -uroot clearsenses_v2 products_special_subcategories > /tmp/products_special_subcategories.sql"
#system "mysql -uroot --execute=\"DROP DATABASE IF EXISTS clearsenses_v2;\""
#system "mysql -uroot --execute=\"CREATE DATABASE clearsenses_v2 CHARACTER SET utf8 COLLATE utf8_unicode_ci;\""

#puts "Importing the Mansur DB to clearsenses_v2 and defining SPLIT_STR function..."
#system "mysql -u root clearsenses_v2 < /tmp/mansur_dump_#{time}.sql"

#system <<-EOF
#mysql -u root clearsenses_v2 --execute="
#CREATE FUNCTION SPLIT_STR(
# x VARCHAR(255),
# delim VARCHAR(12),
# pos INT
#)
#RETURNS VARCHAR(255)
#RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
#      LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
#      delim, '');"
#EOF

#puts "Creating products_special_subcategories table..."
#CreateProductSpecialSubcategory.up

#puts "You want to populate ProductSpecialSubCategory from server(may take a lot of time)? (Y/N)"
#choice = gets.chomp
#if choice == "Y"
#	puts "Populating ProductsSpecialSubcategory table(make sure url.txt is present)..."
#	puts "Continue(Y/N)..."
#	if gets.chomp == "Y"
#		p = ProductSpecialSubcategory.new
#		p.populate
#	else
#		return true
#	end
#else
#	system "mysql -u root clearsenses_v2 < /tmp/products_special_subcategories.sql"
#end

#puts "Creating Dump of new Database Clearsenses_v2(wrong image path) as /tmp/clearsenses_v1.sql..."
#system "mysqldump -uroot clearsenses_v2 > /tmp/clearsenses_v1.sql"

#puts "Creating new DATABASE clearsenses_v1..."
#system "mysql -u root --execute=\"DROP DATABASE IF EXISTS clearsenses_v1;\""
#system "mysql -u root --execute=\"CREATE DATABASE clearsenses_v1 CHARACTER SET utf8 COLLATE utf8_unicode_ci;\""

#puts "Importing the clearsenses_v2 to clearsenses_v1..."
#system "mysql -u root clearsenses_v1 < /tmp/clearsenses_v2.sql"

#puts "changing image path in clearsenses_v2 Database..."
#system "mysql -uroot clearsenses_v2 --execute=\"update product set image_path=REVERSE(SPLIT_STR(REVERSE(image_path), '/', 1));\""

#puts "Creating Dump of new Database Clearsenses_v2(correct image path) as /tmp/clearsenses_v2.sql..."
#system "mysqldump -uroot clearsenses_v2 > /tmp/clearsenses_v2.sql"


#puts "COMPLETE....Hurray :)"
