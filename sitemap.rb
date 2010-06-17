require 'rubygems'
require 'pp'
require 'active_record'
#require 'logger'
require 'exotic_migrator'
require 'ar-extensions'

#$sold_log = Logger.new("sold.log")
#$prods_log = Logger.new("prods.log")
SITEMAP_FILE_PATH = "/home/akshay/Documents/exotic_india/sitemap/"
ActiveRecord::Base.establish_connection(
  						:adapter  =>  "mysql",
  						:host  =>  "localhost",
   					  :username  =>  "root",
    					:database  =>  "mansur"
)
#ActiveRecord::Base.logger = Logger.new(STDOUT)
#ActiveRecord::Base.logger.level = Logger::DEBUG
module Sitemap
  class CreateSitemapProd < ActiveRecord::Migration
    def self.up
      create_table :sitemap_products do |t|
#        t.integer :id, :primary_key => false, :auto_increment => false
        t.string :code, :limit => 25
        t.string :filename, :limit => 100
        t.boolean :sold, :default=>false
        t.timestamps
      end
    end

    def self.down
      drop_table :sitemap_products
    end
  end

  class CreateSitemapSpecialSubcategory < ActiveRecord::Migration
    def self.up
      create_table :sitemap_special_subcategories do |t|
        t.integer :product_id
        t.string :filename, :limit => 100
        t.boolean :sold, :default=>false
        t.timestamps
      end
    end

    def self.down
      drop_table :sitemap_special_subcategories
    end
  end

  class SitemapProd < ActiveRecord::Base
    set_table_name :sitemap_products
    attr_accessible :id, :code, :filename, :sold, :created_at, :updated_at

    def self.collect
      find(:all, :select => "code,filename,sold")
    end

    def self.run
      prod_files = get_prod_files
      puts "Total Product Files: #{prod_files.length}"
      read_and_insert_prods(prod_files,0)
      
      sold_prod_files = get_sold_prod_files
      puts "Total Sold Product Files: #{prod_files.length}"
      read_and_insert_prods(sold_prod_files,1)
    end

    def self.get_prod_files
      files = `cd #{SITEMAP_FILE_PATH}; ls *.prods`
      files.split(/\n/)
      #return [""]
    end

    def self.get_sold_prod_files
      files = `cd #{SITEMAP_FILE_PATH}; ls *.soldprods`
      files.split(/\n/)
      #return ["audiovideo_76.prods"]
    end

    def self.read_and_insert_prods(files, sold)
      fields = [:code, :filename, :sold]
      data = []
      
      files.each_with_index do |file, i|
        puts "reading #{file}"
        f = File.open("#{SITEMAP_FILE_PATH}#{file}", "r").read
        skus = f.scan(/:\w+\d+\n/).collect{|a| a.gsub(/(:|\n)/,"")}
        skus.each do |sku|
          data << SitemapProd.new(:code=>sku, :filename=>file.split(".")[0], :sold=>sold)
          #SitemapProd.create(:code => sku, :filename => file.split(".")[0], :sold => sold)
        end
      end
      puts "SSS -> " + data.length.to_s
      #puts data.inspect
     
      @options = {:validate => false} 
      ActiveRecord::Base.transaction do
        SitemapProd.import data, @options
      end
      puts "done"
    end
  end

  class SitemapSpecialSubcategory < ActiveRecord::Base
    set_table_name :sitemap_special_subcategories
    attr_accessible :id,:code, :filename, :sold

    def self.run
      products = {}
      NewProduct.collect(:select => "id,code").collect{|p| products[p.code] = p.id}
      sitemap_products = SitemapProd.collect
      fields = []
      sitemap_products.each do |prod|
        product_id = products[prod.code]
        filenames = SpecialBrowseLinkNew.find(:all, :select => "filename,sold", :conditions => ['tablename = ? and catname = ?', prod.filename.split('_')[0], prod.filename.split('_')[1]])
      end 
    end
  end
end


# to run the code
Sitemap::CreateSitemapProd.down
Sitemap::CreateSitemapProd.up
#Sitemap::CreateSitemapSpecialSubcategory.up
Sitemap::SitemapProd.run
#Sitemap::SitemapSpecialSubcategory.run
