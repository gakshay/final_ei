require 'rubygems'
require 'pp'
require 'active_record'
require 'logger'
require 'ar-extensions'
require 'exotic_scrapping'

$log = Logger.new('server.log')

FILE_PATH = "/home/akshay/Projects/final_ei/url.txt"
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

# uncomment this line if you want to migrate

#CreateProductSpecialSubcategory.up

# models
class Product < ActiveRecord::Base
    set_table_name "product"
    belongs_to :category
    has_and_belongs_to_many :subcategories, :join_table => "product_subcategories"
    has_and_belongs_to_many :special_subcategories, :join_table => "products_special_subcategories"
end

class Category < ActiveRecord::Base
   has_many :subcategories, :dependent=> :destroy
   has_many :new_products
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

#script
class ProductSpecialSubcategory 
  def initialize
    @products = {}
    Product.find(:all, :select => "id, code").collect{|a| @products[a.code] = a.id }
    @categories = {}
    Category.find(:all, :select => "id, name").collect{|a| @categories[a.name] = a.id }
    @sub_categories = {}
    Subcategory.find(:all, :select => "id, name, category_id").collect{|a| @sub_categories["#{a.name.gsub(/\s/,'')}_#{a.category_id}"] = a.id }
    @special_subcategories = {}
    SpecialSubcategory.find(:all, :select => "id, filename, subcategory_id").collect{|a| @special_subcategories["#{a.filename.gsub(/\s/,'')}_#{a.subcategory_id}"] = a.id }
    @file = File.open(FILE_PATH, "r")
    @robot = ExoticScapping.new
  end
  
  def populate
    File.open(FILE_PATH, "r") do |line|
      while (data = line.gets)
        $log.info("***********#{data}********")
        link, c, s, p = separate_csp(data)
        $log.debug("link: #{link}, C: #{c}, S: #{s}, P: #{p}")
        skus = @robot.fetch(link)
        unless skus.blank?
          $log.debug("SKUS: #{skus.join(", ")}")
          products = read_products_from_sku(skus)
          $log.debug("Products found: #{products.collect(&:id).join(", ")}")
          special_subcategory = get_special_subcategory(c,s,p)
          $log.debug("Special Subcategory: #{special_subcategory.id}")
          special_subcategory.products << products unless special_subcategory.blank?
        end
      end
    end
  end

  def separate_csp(data)
    data = data.split(/\s/)
    link = data[0]
    invalue = link.gsub("http://exoticindia.com/","").split(/\//)
    c = invalue[data.index("C")-1] rescue nil
    s = invalue[data.index("S")-1] rescue nil
    p = invalue[data.index("P")-1] rescue nil
    return link + "xmllist", c, s, p 
  end

  def read_products_from_sku(skus)
    ids = []
    skus.each do |sku|
      ids  << @products[sku]
    end
    products = Product.find(:all, :conditions => ['id in (?)', ids.compact])
    return products
  end

  def get_special_subcategory(c,s,p)
    category_id = @categories[c]
    $log.debug("Category id : #{category_id}")
    subcategory_id = @sub_categories["#{s}_#{category_id}"]
    $log.debug("Sub Category id : #{subcategory_id}")
    ssid = @special_subcategories["#{p}_#{subcategory_id}"]
    special_subcategory = SpecialSubcategory.find_by_id ssid
    return special_subcategory
  end
end

p = ProductSpecialSubcategory.new
p.populate
