require 'rubygems'
require 'pp'
require 'active_record'
require 'logger'
require 'exotic_migrator'
require 'ar-extensions'

SITEMAP_FILE_PATH = "/home/akshay/Documents/exotic_india/sitemap/"
ActiveRecord::Base.establish_connection(
  						:adapter  =>  "mysql",
  						:host  =>  "localhost",
   					  :username  =>  "root",
    					:database  =>  "mansur"
)
# models
class CSP < ActiveRecord::Base
  set_table_name :sitemap_products

  def self.collect
    find(:all, :select => "code,filename,sold", :limit => 100000, :offset => 100000)
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
    puts "Products length: " + products.length.to_s
    special_browse = SpecialBrowseLink.find(:all, :select => "id,filename,tablename,catname")
    sitemap_products = SitemapProd.collect
    fields = [:product_id, :special_browse_id, :special_browse_name, :sold]
    data = []
    sitemap_products.each do |prod|
      #puts "Product : #{prod.inspect}"
      product_id = products[prod.code]
      names = special_browse.select{|f| f if f.tablename == prod.filename.split('_')[0] and f.catname.to_s == prod.filename.split('_')[1].to_s} unless product_id.nil?
      unless names.blank?
        names.each do |n|
          data << [product_id, n.id, n.filename, prod.sold]
        end
      end
    end
    puts "data length" + data.length.to_s
    unless data.empty?
      @options = {:validate => false} 
      ActiveRecord::Base.transaction do
        SitemapSpecialSubcategory.import fields, data, @options
      end
    end
    return true
  end
end
