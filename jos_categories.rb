require 'jos_models'
require 'jos_article'
require 'jos_category_constant'
$log = Logger.new("jos.log")

ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :username => "root",
            :database => "clearsenses_v3"
					)

@prod_fields = [:product_id, :vendor_id, :product_parent_id, :product_sku, :product_s_desc, :product_desc, 
:product_thumb_image, :product_full_image, :product_publish, :product_weight, :product_weight_uom, 
:product_length, :product_width, :product_height, :product_lwh_uom, :product_url, :product_in_stock, 
:product_available_date, :product_availability, :product_special, :product_discount_id, :ship_code_id, 
:cdate, :mdate, :product_name, :product_sales, :attribute, :custom_attribute, :product_tax_id, :product_unit, 
:product_packaging, :child_options, :quantity_options, :child_option_ids, :product_order_levels, :dimension, 
:material, :specialbuyer, :isbn, :author, :publisher, :description, :pages, :cover_type, :edition, :keyword]
@user_fields = [:id, :name, :username, :email, :password, :usertype]
@prod_data = []
@user_data = []
@review_data = []
@prod_sp_sub = []
@jvpp = []
@jvpcx = []
@jvpmx = []
@oldcode = ""
@prod = 1
@user = 1
@password = Digest::MD5.hexdigest("exotic123456")
@mkp = 1000

JosVmCategory.instance_eval do 
  def migrate
    categories = Category.all(:include => :subcategories)
    i = 0
    categories.each do |category|
      jos_cat = JosVmCategory.new(
                          :category_name => MAP2[CATHASH[category.name]][0], 
                          :category_description => category.description, 
                          :category_publish => "Y", 
                          :category_browsepage => "browse_1", 
                          :products_per_row => 3, 
                          :vendor_id => 1,
                          :category_flypage => "flypage.tpl",
                          :list_order => MAP2[CATHASH[category.name]][1]
                          )
      puts category.name
      jos_cat.category_id = CATHASH[category.name]
      jos_cat.save!
      JosVmCategoryXref.create(:category_parent_id => 0, :category_child_id => jos_cat.category_id)

      category.subcategories.each do |subcategory|
        jos_sub_cat = JosVmCategory.new(
                          :category_description => subcategory.description, 
                          :category_publish => "Y", 
                          :category_browsepage => "browse_1", 
                          :products_per_row => 3, 
                          :vendor_id => 1,                        
                          :category_flypage => "flypage.tpl"
                          )

         arr = MAP1[jos_cat.category_id].select {|c| c if MAP2[c][0].downcase == subcategory.name.downcase }
         unless arr.blank?
           jos_sub_cat.category_name = MAP2[arr[0]][0]
           jos_sub_cat.list_order = MAP2[arr[0]][1]
           jos_sub_cat.category_id = arr[0] 
           jos_sub_cat.save!
          JosVmCategoryXref.create(:category_parent_id => jos_cat.category_id, :category_child_id => jos_sub_cat.category_id)
         else
           puts "Subcategory not matched: #{subcategory.name}" 
         end
      end
    end
  end
end

JosVmSpecialbrowse.instance_eval do
  def update_subcategory_id
    specials = JosVmSpecialbrowse.all(:select => 'id,subcategory_id')
    specials.each do |sp|
      sp.update_attributes(:subcategory_id => MAP3[sp.subcategory_id])
    end
  end
end

def product_insert(product)
  [@prod, 1, 0, product['code'],product['title'], product['brief_comments'], product['image_path'], product['image_path'], product['publish_type'], product['prod_weight'], product['weight_unit'], product['prod_length'], product['prod_width'], product['prod_height'], '', '', '50', '1276041600', '', 'N', '0', '', '1276079207', '1276158913', product['title'], '0', '', '', 0, '', '', '', '', '', '', product['dimension'], product['material'], product['specialbuyer'], product['isbn'], product['author'], product['publisher'], product['description'], product['pages'], product['cover_type'], product['edition'], product['keyword']]
end

def product_review(pid)
  reviews = ProductReview.find(:all, :select => "name,id,comments", :conditions => ['product_id = ?', pid])
  reviews.each do |review|
    @user_data << [@user, review["name"], "exotic_#{review['id']}#{@mkp}", "exotic_#{review['id']}#{@mkp}@exoticindia.com", @password, 'Registered']
    @review_data << JosVmProductReview.new(:product_id => @prod, :comment => review["comments"], :userid => @user, :published => 1)
    @mkp += 1
    @user += 1
    if @user == 62
      @user_data << [62, 'Administrator','admin', "admin@admin.com", Digest::MD5.hexdigest("admin"),"Super Administrator"]
      @user += 1
    end
  end
end

def product_special_subcategories1(pid)
  results = ActiveRecord::Base.connection.select_all("select product_id, special_subcategory_id from products_special_subcategories where product_id=#{pid}")
  results.each do |row|
    @prod_sp_sub << ProductSpecialSubCategory1.new(:product_id => @prod, :special_subcategory_id => row["special_subcategory_id"])
  end
end

def get_new_category(product)
  query = <<-EOF
  SELECT DISTINCT t4.category_name as sub_category, t4.category_id as sub_category_id, t6.category_name as parent_category, t6.category_id as parent_category_id
	FROM (
	SELECT t1.*, t2.*
	FROM jos_vm_category t1
	INNER JOIN jos_vm_category_xref t2 ON t1.category_id = t2.category_child_id ) t4
	INNER JOIN jos_vm_category_xref t5 ON t4.category_parent_id = t5.category_parent_id 
	INNER JOIN jos_vm_category t6 ON t5.category_parent_id = t6.category_id 
	WHERE t4.category_id = "#{MAP3[product['sub_category_id'].to_i]}"
	ORDER BY t6.category_id, t4.category_name
EOF
ActiveRecord::Base.connection.select_one(query)
end

def product_price_mf_xref(product)
    @jvpp << JosVmProductPrice.new(:product_id => @prod, :product_price => product["price"], :product_currency => "USD", :product_price_vdate => 0,:product_price_edate => 0, :cdate => '1275721495',:mdate => '1276256884',:shopper_group_id => 5, :price_quantity_start => 0, :price_quantity_end => 0)
    @jvpmx << JosVmProductMfXref.new(:manufacturer_id => 1, :product_id => @prod)
end

def product_category_xref(cat_result)
  @jvpcx << JosVmProductCategoryXref.new(:category_id => cat_result["sub_category_id"].to_i, :product_id => @prod)
end


def jos_vm_product_migration
  products_query = <<-EOF
  SELECT t1.id AS parent_category_id, t1.name AS parent_category, t2.id AS sub_category_id, t2.name AS sub_category, t4.code, t4.title, t4.price, t4.image_path, t4.prod_height, t4.prod_width, t4.prod_length, t4.dimension, t4.prod_weight, t4.weight_unit, t4.weight_to_show, t4.brief_comments, t4.material, t4.frame, t4.availability, t4.archive, t4.sold, t4.specialbuyer, t4.date_added, t4.isbn, t4.author, t4.publisher, t4.description, t4.pages, t4.cover_type, t4.keyword, t4.edition, case when ( (t4.availability > 0 or t4.sold = 0 or t4.sold LIKE '2%') and archive =0 ) then 'Y' else 'N' end as publish_type,t4.id as product_id
  FROM categories t1
  INNER JOIN subcategories t2 ON t1.id = t2.category_id
  INNER JOIN product_subcategories t3 ON t3.subcategory_id = t2.id
  INNER JOIN product t4 ON t4.id = t3.product_id
  WHERE 1 = 1
  ORDER BY t4.code
  LIMIT 10000
EOF

  products = ActiveRecord::Base.connection.select_all(products_query)
  puts "Total Results from query: #{products.count}"
  puts Time.now
  products.each_slice(10000).to_a.each do |prods|
    @prod_data.clear
    @user_data.clear
    @review_data.clear
    @prod_sp_sub.clear
    @jvpp.clear
    @jvpcx.clear
    @jvpmx.clear
    prods.each do |product|
      cat_result = get_new_category(product)
      product_category_xref(cat_result) unless cat_result.blank?
      if @oldcode != product['code'].strip
        @prod_data << product_insert(product)
        product_review(product["product_id"])
        product_special_subcategories1(product["product_id"])
        product_price_mf_xref(product)
        @oldcode = product['code'].strip
        @prod += 1
      end
    end

    unless @prod_data.empty?
      @options = {:validate => false} 
      ActiveRecord::Base.transaction do
        JosVmProduct.import @prod_fields, @prod_data, @options
        JosUser.import @user_fields, @user_data, @options unless @user_data.blank?
        JosVmProductReview.import @review_data, @options unless @review_data.blank?
        ProductSpecialSubCategory1.import @prod_sp_sub, @options unless  @prod_sp_sub.blank?
        JosVmProductPrice.import @jvpp, @options unless @jvpp.blank?
        JosVmProductCategoryXref.import @jvpcx, @options unless @jvpcx.blank?
        JosVmProductMfXref.import @jvpmx, @options unless @jvpmx.blank?
      end
    end
    $log.info("Prod: #{@prod}, User: #{@user}, MKP: #{@mkp}")
  end
  puts "Done"
  puts Time.now
end

#puts "migrating jos schema..."
#system "mysql -u root clearsenses_v3 < jos_schema.sql"

#puts "migrating JOS categories..."
#JosVmCategory.migrate
#puts "now running products migration script..."
#jos_vm_product_migration

puts "migrating jos article, webeeComment, product_type_3 schema..."
system "mysql -u root clearsenses_v3 < jos_article_schema.sql"

#puts "now running jos article migration script..."
#article_migrate

#puts "Migrating jos_vm_specialbrowse..."
#system "mysql -u root clearsenses_v3 --execute=\"DROP TABLE IF EXISTS jos_vm_specialbrowse; CREATE TABLE jos_vm_specialbrowse SELECT * FROM specialbrowse_links_new;\""
#puts "Updating Subcategory_id jos_vm_specialbrowse..."
#JosVmSpecialbrowse.update_subcategory_id

puts "migrating jos_vm_product_type..."
JosVmProductType3.populate
## Now take the dump and migrate in the main DB

#system "mysqldump -u root clearsenses_v3 jos_users jos_vm_category jos_vm_category_xref jos_vm_product jos_vm_product_reviews jos_vm_product_category_xref jos_vm_product_mf_xref jos_vm_product_price products_special_subcategories1 jos_content jos_webeeComment_Comment jos_vm_specialbrowse jos_vm_product_type jos_vm_product_type_3 jos_vm_product_product_type_xref jos_vm_product_type_parameter product categories subcategories specialbrowse_links_new > jos_limited_dump_06082010.sql"

