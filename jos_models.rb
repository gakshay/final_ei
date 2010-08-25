require 'rubygems'
require 'pp'
require 'active_record'
require 'constants'
SQL_QUERY_LIMIT = 10000
require 'logger'
require 'ar-extensions'
require 'exotic_models'
require 'digest/md5'
require 'exotic_models'

ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :username => "root",
            :database => "clearsenses_v3"
					)

class JosVmCategoryXref < ActiveRecord::Base
  set_table_name :jos_vm_category_xref
end

class JosVmProductCategoryXref < ActiveRecord::Base
  set_table_name :jos_vm_product_category_xref
end

class JosVmProductMfXref < ActiveRecord::Base
  set_table_name :jos_vm_product_mf_xref
end

class JosVmProduct < ActiveRecord::Base
  set_table_name :jos_vm_product
  set_primary_key :product_id
end

class JosVmProductPrice < ActiveRecord::Base
  set_table_name :jos_vm_product_price
end

class JosUser < ActiveRecord::Base
  set_table_name :jos_users
end

class JosVmProductReview < ActiveRecord::Base
  set_table_name :jos_vm_product_reviews
end

class ProductSpecialSubCategory1 < ActiveRecord::Base
  set_table_name :products_special_subcategories1
end

class JosVmCategory < ActiveRecord::Base
  set_table_name :jos_vm_category
  set_primary_key :category_id
end

class JosVmSpecialbrowse < ActiveRecord::Base
  set_table_name :jos_vm_specialbrowse
end

class JosContent < ActiveRecord::Base
  set_table_name :jos_content
end

class JosWebeeComment < ActiveRecord::Base
  set_table_name :jos_webeeComment_Comment
end

class JosVmProductType3 < ActiveRecord::Base
  set_table_name :jos_vm_product_type_3

  def self.populate
    fields = [:product_id, :metadata, :dimension, :material, 
    :specialbuyer, :isbn, :author, :publisher, :pages, :cover_type, :edition, :description  ]
    ref_fields = [:product_id, :product_type_id]
    data = []
    ref_data = []
    products = JosVmProduct.all(:select => "product_id,keyword,dimension,material, 
    specialbuyer,isbn,author,publisher,pages,cover_type,edition,description")
    products.each do |product|
      data << [product.product_id, product.keyword, product.dimension, product.material, product.specialbuyer, product.isbn, product.author, product.publisher, product.pages, product.cover_type, product.edition, product.description]
      ref_data << [product.product_id, 3]
    end
    unless data.empty?
      @options = {:validate => false} 
      ActiveRecord::Base.transaction do
          JosVmProductType3.import fields, data
          JosVmProductProductTypeXref.import ref_fields, ref_data
      end
    end
  end
end

class JosVmProductProductTypeXref < ActiveRecord::Base
  set_table_name :jos_vm_product_product_type_xref
end

class JosColor < ActiveRecord::Base
  set_table_name :jos_colors
  has_and_belongs_to_many :products, :join_table => "jos_color_products", :foreign_key => :color_id, :association_foreign_key => :product_id
end


