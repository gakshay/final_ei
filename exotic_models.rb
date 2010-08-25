require 'rubygems'
require 'pp'
require 'active_record'
require 'logger'
require 'ar-extensions'

ActiveRecord::Base.establish_connection(
  						:adapter  =>  "mysql",
  						:host  =>  "localhost",
   					  :username  =>  "root",
    					:database  =>  "clearsenses_v2"
)

#migration
class CreateProductSpecialSubcategory < ActiveRecord::Migration
    def self.up
      create_table :products_special_subcategories, :id => false do |t|
        t.string :product_id
        t.string :special_subcategory_id
        t.timestamps
      end
    end

    def self.down
      drop_table :sitemap_products
    end
end

# models
class Product < ActiveRecord::Base
    set_table_name "product"
    set_primary_key "id"
    belongs_to :category
    has_and_belongs_to_many :subcategories, :join_table => "product_subcategories"
    has_and_belongs_to_many :special_subcategories, :join_table => "products_special_subcategories"
end

class Category < ActiveRecord::Base
   has_many :subcategories, :dependent=> :destroy
   has_many :products
end

class Subcategory < ActiveRecord::Base
   belongs_to :category
   has_and_belongs_to_many :products, :join_table => "product_subcategories"
   has_many :special_subcategories
end

class SpecialSubcategory < ActiveRecord::Base
   set_table_name :specialbrowse_links_new
   belongs_to :subcategory
   has_and_belongs_to_many :products, :join_table => "products_special_subcategories"
end

class ProductReview < ActiveRecord::Base
   set_table_name :product_reviews
end

class ArticleReview < ActiveRecord::Base
   set_table_name :article_reviews
end

class ArticleNew < ActiveRecord::Base
   set_table_name :articles_new
end
