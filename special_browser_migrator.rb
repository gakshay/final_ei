require "rubygems"
require "exotic_migrator"

class SpecialBrowseLink < ActiveRecord::Base
  set_table_name "specialbrowse_links"

  def self.migrate_specialbrowse
  	self.find(:all).each do |sp_browse|
		  meta_generator = MetaGenerator.find(:first,:conditions=>['category=? and tablename=?',sp_browse.catname,sp_browse.tablename])
		  category = Category.find(:first, :conditions => ["name = ?", meta_generator.tablename.strip], :select => "id")
			sub_category = Subcategory.find(:first,:conditions=>['name = ? and category_id = ?',meta_generator.categoryname.strip, category.id])
		  unless sub_category.blank?                
		  	SpecialBrowseLinkNew.create(:filename => sp_browse.filename,
																:subcategory_id => sub_category.id,
																:dropdownonly => sp_browse.dropdownonly,
																:artists => sp_browse.artists,
																:iscolor => sp_browse.iscolor,
																:available => sp_browse.available,
																:coltime => sp_browse.coltime,
																:keyword => sp_browse.coltime,
																:description => sp_browse.description,
																:titletag  => sp_browse.titletag,
																:buttontext => sp_browse.buttontext,
																:buttoncolor => sp_browse.buttoncolor,
																:specials_nocat => sp_browse.specials_nocat,
																:specials_mustorcat => sp_browse.specials_mustorcat,
																:specials_mustandcat => sp_browse.specials_mustandcat,
																:specials_wt => sp_browse.specials_wt,
																:specials_exclflds => sp_browse.specials_exclflds,
																:specials_modifier => sp_browse.specials_modifier,
																:specials_extra_words => sp_browse.specials_extra_words)
			end
		end
		puts "done"
  end
end

SpecialBrowseLink.migrate_specialbrowse
