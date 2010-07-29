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
module Affiliation
	class CreateNewAffiliate < ActiveRecord::Migration
    def self.up
      create_table :affiliate_new, :id => false do |t|
        t.string :affid, :null => false, :limit => 50, :default => "", :primary_key => true
        t.string :pwd, :limit => 50
        t.string :name, :limit => 200
        t.string :hostname
        t.string :email, :limit => 200
				t.float :share
        t.string :address1
        t.string :address2
        t.date :last_processed
        t.string :city, :limit => 100
        t.string :state, :limit => 100
        t.string :zip, :limit => 100
        t.string :country, :limit => 100
        t.string :phone, :limit => 20
        t.string :fax, :limit => 20
        t.string :payment, :limit => 15
        t.timestamp   :coltime, :null => false
      end
    end

    def self.down
      drop_table :affiliate_new
    end
  end



	class Affiliate < ActiveRecord::Base
		set_table_name :affiliate
	  def self.collect(options = {})
  		find(:all, options)
	  end
	end #affiliate

	class Affdetails < ActiveRecord::Base
		set_table_name :affdetails
		def self.collect(options = {})
  		find(:all, options)
	  end
	end # affdetails

	class AffliateHostname < ActiveRecord::Base
		set_table_name :affiliate_hostname
		def self.collect(options = {})
			find(:all, options)
		end
	end # affiliate_hostname

	class Affsales < ActiveRecord::Base
		set_table_name :affsales
		def self.collect(options = {})
			find(:all, options)
		end
	end # affsales

	class Affpayments < ActiveRecord::Base
		set_table_name :affpayments
		def self.collect(options = {})
			find(:all, options)
		end
	end # affpayments

	class AffiliateNew < ActiveRecord::Base
		set_table_name :affiliate_new
	  def self.collect(options = {})
  		find(:all, options)
	  end

	  def self.migrate_affiliate
		  fields = [:id, :pwd, :name, :hostname, :email, :share, :address1, :address2, :last_processed, :city, :state, :zip, :country, :phone, :fax, :payment, :coltime]
	  	old_affiliates = Affiliate.collect
	  	hostnames = {}
	  	AffliateHostname.collect.collect{|h| hostnames[h.id] = h.hostname}
	  	data = []
	  	old_affiliates.each { |aff|
	  		data << AffiliateNew.new(:affid => aff.id, 
	  														 :pwd => aff.pwd, 
	  														 :name => aff.name,
															   :hostname => hostnames[aff.id],
															   :email => aff.email,
															   :share => aff.share,
															   :address1 => aff.address1, 
															   :address2 => aff.address2, 
															   :last_processed => aff.last_processed, 
															   :city => aff.city, 
															   :state => aff.state, 
															   :zip => aff.zip, 
															   :country => aff.country, 
															   :phone => aff.phone, 
															   :fax => aff.fax, 
															   :payment => aff.payment, 
															   :coltime => aff.coltime
															   )
	  	}
	  	puts "data length" + data.length.to_s
      @options = {:validate => false} 
      ActiveRecord::Base.transaction do
        AffiliateNew.import data, @options
      end
      puts "done"
	  end
	end #affiliate
end # Affiliation 
