require 'rubygems'
require 'pp'
require 'active_record'
require 'logger'
require 'exotic_migrator'
require 'ar-extensions'

$shop_log = Logger.new("shop.log")
ActiveRecord::Base.establish_connection(
  						:adapter  =>  "mysql",
  						:host  =>  "localhost",
   					  :username  =>  "root",
    					:database  =>  "mansur"
)
module Shopping
	class ShoppingDetails < ActiveRecord::Base
		set_table_name :shoppingdetails
	  def self.collect(options = {})
  		find(:all, options)
	  end
	end #ShoppingDetails

	class Discounttable < ActiveRecord::Base
		set_table_name :discounttable
	  def self.collect(options = {})
  		find(:all, options)
	  end
	end 
	
	class Customers < ActiveRecord::Base
		set_table_name :customers
		def self.collect(options = {})
  		find(:all, options)
	  end

	  def self.not_in_shopping_details
	  	customers = Customers.collect(:select => "userid").collect(&:userid)
	  	puts "Total customers: #{customers.size}"
	  	shopping_details = ShoppingDetails.collect(:select => "userid").collect(&:userid)
	  	puts "Total Shopping details: #{shopping_details.size}"
			discounttable = Discounttable.collect(:select => "email").collect(&:email).uniq
	  	cust = Customers.collect(:select => "email").collect(&:email).uniq
	  	puts "Total Discounttable: #{discounttable.size}"
	  	puts "Customers not in Shopping details: #{(customers-shopping_details).size}"
	  	puts "Shopping details not in customers: #{(shopping_details-customers).size}"
	  	puts "customers not in discounttable: #{(cust - discounttable).size}"
	  	puts "discounttable not in customers: #{(discounttable - cust).size}"
	  end
	end # Customers
end # shopping 

Shopping::Customers.not_in_shopping_details
