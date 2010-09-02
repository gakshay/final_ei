require 'jos_models'
require 'jos_article'
require 'exotic_models'
require 'jos_category_constant'

ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :username => "root",
            :database => "clearsenses_v4"
					)
#ActiveRecord::Base.logger = Logger.new(STDOUT)
$product_type_log = Logger.new("product_type.log")
$type_array = []
$number = 0
class CreateProductType < ActiveRecord::Migration
    def self.up
      create_table "jos_vm_product_type_#{$number}", :id => false do |t|
        t.string :product_id
        t.string :special
        t.timestamps
      end
    end

    def self.down
      drop_table "jos_vm_product_type_#{$number}".to_sym
    end
end

class JosVmVariableProduct < ActiveRecord::Base
end

def jos_vm_product_type
	subcategories = Subcategory.all
	subcategories.each do |subcategory|
		$number = MAP3[subcategory.id]
		$product_type_log.info(subcategory.inspect)
		type = JosVmProductType.new(:product_type_name => subcategory.name.gsub(/\s+/,"_"), :product_type_description => subcategory.description, :product_type_publish => "Y")
		type.product_type_id = $number
		type.save!
		JosVmProductTypeParameter.create(:product_type_id => $number, :parameter_name => "special", :parameter_label => "special", :parameter_list_order => 1, :parameter_type => "T", :parameter_values => subcategory.special_subcategories.collect(&:filename).join(";"), :parameter_multiselect => "Y" )
		CreateProductType.up
		$type_array << $number
		@fields = [:product_id, :special]
		@type_fields = [:product_id, :product_type_id]
		@data = []
		@type_data = []
		cat_products = JosVmProductCategoryXref.find_all_by_category_id $number
		products = JosVmProduct.find cat_products.collect(&:product_id)
		products.each do |product|
			product.jos_vm_specialbrowse.each do |ss|
				@data << [product.id, ss.filename]
				@type_data << [product.id, $number]
			end
		end
		data = @data.uniq
		type_data = @type_data.uniq
		$product_type_log.info("Subcategory : #{$number} => #{subcategory.name}. Data collected : #{data.length}/#{products.length}")
		JosVmVariableProduct.set_table_name "jos_vm_product_type_#{$number}"
		@options = {:validate => false}
		ActiveRecord::Base.transaction do
      JosVmVariableProduct.import @fields, data, @options unless data.blank?
      JosVmProductProductTypeXref.import @type_fields, type_data, @options unless type_data.blank?
    end
    puts "done"
	end
end

