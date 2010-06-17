require 'rubygems'
require 'pp'
require 'active_record'
require 'logger'
require 'exotic_migrator'
$sold_log = Logger.new("sold.log")
$prods_log = Logger.new("prods.log")
SITEMAP_FILE_PATH = "/home/akshay/Documents/exotic_india/sitemap/"
ActiveRecord::Base.establish_connection(
  						:adapter  =>  "mysql",
  						:host  =>  "localhost",
   					  :username  =>  "root",
    					:database  =>  "mansur"
)
module Sitemap
  class CreateSitemapProd < ActiveRecord::Migration
    def self.up
      create_table :sitemap_prods do |t|
        t.string :code, :limit => 25
        t.string :filename, :limit => 100
        t.boolean :sold, :default=>false
        t.timestamps
      end
    end

    def self.down
      drop_table :sitemap_prods
    end
  end

  class CreateSitemapSpecialSubcategory < ActiveRecord::Migration
    def self.up
      create_table :sitemap_special_subcategories do |t|
        t.integer :product_id
        t.string :code, :limit => 25
        t.string :filename, :limit => 100
        t.boolean :sold, :default=>false
        t.timestamps
      end
    end

    def self.down
      drop_table :sitemap_special_subcategories
    end
  end

  class InitialMigration < ActiveRecord::Base
    set_table_name :sitemap_prods

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
    end

    def self.get_sold_prod_files
      files = `cd #{SITEMAP_FILE_PATH}; ls *.soldprods`
      files.split(/\n/)
    end

    def self.read_and_insert_prods(files, sold)
      files.each do |file|
        puts "reading #{file}"
        f = File.open("#{SITEMAP_FILE_PATH}#{file}", "r").read
        skus = f.scan(/:\w+\d+\n/).collect{|a| a.gsub(/(:|\n)/,"")}
        skus.each do |sku|
          InitialMigration.create(:code => sku, :filename => file.split(".")[0], :sold => sold)
        end
      end
    end
  end

  class FinalMigration < ActiveRecord
    set_table_name :sitemap_special_subcategories
    products = {}
    NewProduct.collect(:select => "id,code").collect{|p| products[p.code] = p.id}
    sitemap_products = 
    
  end
end


# to run the code
#Sitemap::CreateSitemapProd.down
Sitemap::CreateSitemapProd.up
Sitemap::InitialMigration.run
