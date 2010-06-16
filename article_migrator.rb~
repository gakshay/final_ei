require "rubygems"
require "exotic_migrator"

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

