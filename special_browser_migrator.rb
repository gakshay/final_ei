require "rubygems"
require "exotic_migrator"

class SpecialBrowseLinkNew < ActiveRecord::Base
    set_table_name "specialbrowse_links_new"
    def self.migrate_specialbrowse
    	self.find(:all).each do |sp_browse|
		meta_generator = MetaGenerator.find(:first,:conditions=>['category=? and tablename=?',sp_browse.catname,sp_browse.tablename])
                sub_category = Subcategory.find(:first,:conditions=>['name=?',meta_generator.categoryname.strip])
		unless sub_category.blank?                
  			sp_browse.subcategory_id = sub_category.id
			sp_browse.save 
                        puts sp_browse.id
		end
        end
    end
end

SpecialBrowseLinkNew.migrate_specialbrowse
