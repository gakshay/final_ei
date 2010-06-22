require "rubygems"
require "exotic_migrator"


Category.categories_migrator
Subcategory.sub_categories_migrator

NewProduct.merge_book_category


product_migrator = ProductMigrator.new
product_count = Product.count_by_sql("select count(*) from products where maincategory not in ('audiovideo','ayurveda')")
i=0

while(i<product_count)
	product=Product.find(:all,:conditions=>["maincategory not in ('audiovideo','ayurveda')"],:offset=>i,:limit=>SQL_QUERY_LIMIT)
	i += SQL_QUERY_LIMIT
        product.each { |product|		
     		product_migrator.migrating_product(product)
	}
end


SpecialBrowseLinkNew.migrate_specialbrowse

ProductAttr.migrate_ring_sizes

SubcategoryAttributeLabel.saree_labels
SubcategoryAttributeLabel.salwar_labels
SubcategoryAttributeLabel.ring_labels

SubcategoryAttributeValue.saree_values
SubcategoryAttributeValue.salwar_values
SubcategoryAttributeValue.ring_values

NewArticles.migrate
NewArticlelinks.migrate

NewFeedBack.migrate_site_feeback
ArticleReview.migrate_article_reviews
ProductReview.migrate_product_reviews


#migrating all registered user irrespective of whether they have bought something or not
DiscountTable.migrate_discount_table

#migrating all customer who has bought something but not registered
Customer.migrate_non_registered_user

