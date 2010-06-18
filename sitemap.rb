require 'rubygems'
require 'pp'
require 'active_record'
require 'logger'
require 'exotic_migrator'
require 'ar-extensions'

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
      create_table :sitemap_products do |t|
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

    def self.collect
      find(:all, :select => "code,filename,sold", :limit => 100, :offset => 30000)
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
      fields = [:code, :filename, :sold]
      data = []
      
      files.each_with_index do |file, i|
        puts "reading #{file}"
        f = File.open("#{SITEMAP_FILE_PATH}#{file}", "r").read
        skus = f.scan(/:\w+\d+\n/).collect{|a| a.gsub(/(:|\n)/,"")}
        skus.each do |sku|
          data << SitemapProd.new(:code=>sku, :filename=>file.split(".")[0], :sold=>sold)
        end
      end
      puts "data length" + data.length.to_s
      @options = {:validate => false} 
      ActiveRecord::Base.transaction do
        SitemapProd.import data, @options
      end
      puts "done"
    end
  end

  class SitemapSpecialSubcategory < ActiveRecord::Base
    set_table_name :sitemap_special_subcategories

    def self.run
      products = {}
      NewProduct.collect(:select => "id,code").collect{|p| products[p.code] = p.id}
      filenames = SpecialBrowseLink.find(:all, :select => "filename,tablename,catname")
      sitemap_products = SitemapProd.collect
      fields = [:product_id, :filename, :sold]
      data = []
      sitemap_products.each do |prod|
        puts prod.inspect
        product_id = products[prod.code]
        puts product_id
        names = filenames.collect{|f| f.filename if f.tablename == prod.filename.split('_')[0] and f.catname.to_s == prod.filename.split('_')[1].to_s}
        #names = filenames.find(:all, :select => "filename", :conditions => ['tablename = ? and catname = ?', prod.filename.split('_')[0], prod.filename.split('_')[1]]).collect{|a| a.filename}
        puts names
        unless product_id.nil? && names.blank?
          names.each do |name|
            data << [product_id, name, prod.sold]
          end
        end
      end
       puts "data length" + data.length.to_s
        @options = {:validate => false} 
        ActiveRecord::Base.transaction do
          SitemapSpecialSubcategory.import fields, data, @options
        end
        puts "done"
    end
  end
end


# to run the code
#Sitemap::CreateSitemapProd.down
#Sitemap::CreateSitemapProd.up
Sitemap::CreateSitemapSpecialSubcategory.down
Sitemap::CreateSitemapSpecialSubcategory.up
#Sitemap::SitemapProd.run
Sitemap::SitemapSpecialSubcategory.run
