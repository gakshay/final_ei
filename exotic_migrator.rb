require 'rubygems'
require 'pp'
require 'active_record'
SQL_QUERY_LIMIT=50
require 'logger'
$book_log = Logger.new("books.log")
$logger=Logger.new('product_migrator_err.log')

$articles_log = Logger.new("articles.log")
$articlelinks_log = Logger.new("articlelinks.log")
ARTICLE_FILE_PATH = "/home/suri/exotic_india/articlebodies/"


ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :username => "root",
            :database => "mansur"
					)


class Product < ActiveRecord::Base
    set_table_name "products"
    set_primary_key "code"

    def self.collect(options = {})
    	find(:all, options)
    end
end

class Book < ActiveRecord::Base
    set_table_name "book"
    set_primary_key "code"
    def self.collect(options = {})
    	find(:all, options)
    end
end

class Ringsizes < ActiveRecord::Base
  set_table_name "ringsizes"

  def self.collect()
     find(:all, :select => "code, size, qty")
   end
end

class ProductAttr < ActiveRecord::Base
  set_table_name "product_attr"

  def self.migrate_ring_sizes
   ringsizes = Ringsizes.collect
   products = {}
   NewProduct.find(:all, :select => "id,code").collect{ |p| products[p.code] = p.id}
   ringsizes.each do |r|
    begin
     ProductAttr.create(:product_id => products[r.code], :quantity => r.qty, :label => "size", :value => r.size)
    rescue
      puts r.code
    end
   end
  end
end

class Sareesizes < ActiveRecord::Base
    set_table_name "sareesizes"
  
end


class Salwaar< ActiveRecord::Base
    set_table_name "salwaars"
end


class RingDisplay < ActiveRecord::Base
    set_table_name "ringdisplay"
end

class SubcategoryAttributeLabel < ActiveRecord::Base
    set_table_name "subcategories_attribute_labels"

    def self.saree_labels
      begin
       textile_category_id = Category.find_by_name("textiles",:first,:select=>'id').id
       saree_id = Subcategory.find(:first,:conditions=>['category_id=? and name=?',textile_category_id,"Saris"],:select=>'id').id
       self.create(
                   :subcategory_id=>saree_id,
                   :label1=>"Size",
                   :label2=>"Bust",
		   :label3=>"Waist",
		   :label4=>"Hip",
                   :label5=>"Neck Circumference",
                   :label6=>"Shoulder to shoulder length",
                   :label7=>"Upper arm circumference",
                   :label8=>"Armhole depth"
                  )
      rescue Exception=>e
        puts "Some problem with Sari attribute label migration"
        puts e
      end 
    end

    def self.salwar_labels
      begin
       textile_category_id = Category.find_by_name("textiles",:first,:select=>'id').id
       salwaar_id = Subcategory.find(:first,:conditions=>['category_id=? and name=?',textile_category_id,"Salwar Kameez"],:select=>'id').id
       self.create(
                   :subcategory_id=>salwaar_id,
                   :label1=>"Name",
                   :label2=>"image"
                  )
      rescue Exception=>e
        puts "Some problem with Salwar attribute label migration"
        puts e
      end 
    end

    def self.ring_labels
      begin
       jewelry_category_id = Category.find_by_name("jewelry",:first,:select=>'id').id
       ring_id = Subcategory.find(:first,:conditions=>['category_id=? and name=?',jewelry_category_id,"Rings"],:select=>'id').id
       self.create(
                   :subcategory_id=>ring_id,
                   :label1=>"US",
                   :label2=>"Diameter in inches",
		   :label3=>"Diameter in mm",
		   :label4=>"Circumference in inches",
                   :label5=>"Circumference in mm",
                   :label6=>"British"
                  )
      rescue Exception=>e
        puts "Some problem with Ring Display attribute label migration"
        puts e
      end 
    end


end

class SubcategoryAttributeValue < ActiveRecord::Base
    set_table_name "subcategories_attribute_values"

    def self.saree_values
      begin
       textile_category_id = Category.find_by_name("textiles",:first,:select=>'id').id
       saree_id = Subcategory.find(:first,:conditions=>['category_id=? and name=?',textile_category_id,"Saris"],:select=>'id').id
       Sareesizes.find(:all).each do |sari| 
              self.create(
                   :subcategory_id=>saree_id,
                   :value1=>sari.Size_No,
                   :value2=>sari.Bust,
		   :value3=>sari.Waist,
		   :value4=>sari.Hip,
                   :value5=>sari.Neck_Circumference,
                   :value6=>sari.Shoulder_to_Shoulder_Length,
                   :value7=>sari.Upper_Arm_Circumference,
                   :value8=>sari.Armhole_Depth
                  )
         end
      rescue Exception=>e
        puts "Some problem with Sari attribute label migration"
        puts e
      end 
    end

    def self.salwar_values
      begin
       textile_category_id = Category.find_by_name("textiles",:first,:select=>'id').id
       salwaar_id = Subcategory.find(:first,:conditions=>['category_id=? and name=?',textile_category_id,"Salwar Kameez"],:select=>'id').id
       Salwaar.find(:all).each do |salwar|
                self.create(
                   :subcategory_id=>salwaar_id,
                   :value1=>salwar.name,
                   :value2=>salwar.image
                  )
       end
      rescue Exception=>e
        puts "Some problem with Salwar attribute label migration"
        puts e
      end 
    end

    def self.ring_values
      begin
       jewelry_category_id = Category.find_by_name("jewelry",:first,:select=>'id').id
       ring_id = Subcategory.find(:first,:conditions=>['category_id=? and name=?',jewelry_category_id,"Rings"],:select=>'id').id
       RingDisplay.find(:all).each do |ring| 
               self.create(
                   :subcategory_id=>ring_id,
                   :value1=>ring.us,
                   :value2=>ring.diam_inches,
		   :value3=>ring.diam_mm,
		   :value4=>ring.circ_inches,
                   :value5=>ring.circ_mm,
                   :value6=>ring.british
                  )
       end
      rescue Exception=>e
        puts "Some problem with Ring Display attribute label migration"
        puts e
      end 
    end


end


class NewProduct < ActiveRecord::Base
    set_table_name "new_products"
    #set_primary_key "code"
    belongs_to :category
    has_and_belongs_to_many :subcategories

   	def self.collect(options = {})
    	find(:all, options)
    end
 
    def self.merge_book_category
    	books = Book.collect()
    	books_category_hash = MetaGenerator.category_hash("book")
    	books.each_with_index do |book,i|
        puts "#{i}. #{book.code}"
    		categories = get_categories("BOOK",book.category, books_category_hash)
        begin    		
        p = NewProduct.new(
             :isbn=> book.ISBN,
  				   :title => book.title,
  				   :author => book.author,
  				   :publisher => book.publisher,
  				   :description => book.description,
  				   :pages => book.pages,
  				   :cover_type => book.cover_type,
  				   :edition => book.edition,
  				   :time => book.time,
  				   :price => book.price || "",
  				   :availability => book.availability,
  				   :brief_comments => book.brief_comments,
  				   :date_added => book.date_added,
  				   :sold => book.sold || "",
  				   :image_path => book.URL,
  				   :archive => book.archive,
  				   :coltime => book.coltime,
  				   :transid => book.transid,
  				   :dimension => book.dimension
			)
        p.category_id = 600 #Category.find(:first,:select=>'id',:conditions=>['name=?',"book"]).id
  			p.code = book.code
			  p.save!

        ProductMigrator.new.set_category(p,book)
			rescue Exception => e
			  $book_log.error("Book Save Error: #{e}")
			end
    		end
    		return true
    end

    def self.get_categories(name, category, hash)
    	result = []
    	category = category.scan(/\d+/).collect{ |c| c.to_i}
    	category.each{ |c|	result << BOOK_SUBCATEGORIES[hash[c].to_sym] unless hash[c].blank? }
    	return result.compact.join(",")
    end
end

 class Category < ActiveRecord::Base
   has_many :subcategories, :dependent=> :destroy
   has_many :new_products

   def self.categories_migrator
       puts "Deleting all category and related subcategories if present"
       self.find(:all).each {|cat| cat.destroy }


        MetaGenerator.collect(:conditions=>['category<=0']).each do |main_category|
            begin
		category = self.new(
	                              :name=>main_category.tablename.strip,
				      :description=>main_category.description,
			              :title=>main_category.title,
                                      :previous_id=>main_category.id
		                   )
                category.id = MAIN_CATEGORIES[main_category.tablename.strip.to_sym]
                category.save!
                puts "#{category.id} #{category.name}"
             rescue Exception=>e
               puts(e)
	    end	
	end

   end

end


class Subcategory < ActiveRecord::Base
   belongs_to :category
   has_and_belongs_to_many :new_products

   def self.sub_categories_migrator
        MetaGenerator.collect(:conditions=>['category>0']).each do |sub_category|
            begin
		subcategory = self.new(
	                              :name=>sub_category.categoryname.strip,
				      :description=>sub_category.description,
			              :title=>sub_category.title,
                                      :previous_id=>sub_category.id,
                                      :category_id=>MAIN_CATEGORIES[sub_category.tablename.strip.to_sym]  
		                   )
                category_name = sub_category.categoryname.gsub(" ","_").downcase.to_sym

                case(sub_category.tablename.strip)
  		        when 'beads'
                        	subcategory.id = BEAD_SUBCATEGORIES[category_name]
			when 'book'
                        	subcategory.id = BOOK_SUBCATEGORIES[category_name]
			when 'audiovideo'
                        	subcategory.id = AUDIO_VIDEO_SUBCATEGORIES[category_name]
			when 'ayurveda'
                        	subcategory.id = AYURVEDA_SUBCATEGORIES[category_name]
			when 'paintings'
                        	subcategory.id = PAINTING_SUBCATEGORIES[category_name]
			when 'sculptures'
                        	subcategory.id = SCULPTURE_SUBCATEGORIES[category_name]
			when 'jewelry'
                        	subcategory.id = JEWELRY_SUBCATEGORIES[category_name]
			when 'textiles'
                        	subcategory.id = TEXTILE_SUBCATEGORIES[category_name]
		end
               subcategory.save!
                puts "#{subcategory.id} #{subcategory.name}"
             rescue Exception=>e
               puts(e)
	    end	
	end
   end

end

class SpecialBrowseLink < ActiveRecord::Base
    set_table_name "specialbrowse_links"

    def self.collect(options = {})
    	find(:all, options)
    end
end

class SpecialBrowseLinkNew < ActiveRecord::Base
    set_table_name "specialbrowse_links_new"

    def self.collect(options = {})
    	find(:all, options)
    end
    
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


class MetaGenerator < ActiveRecord::Base
	set_table_name "metagenerator"
        def self.category_hash(tablename)
    		category = {}
    		result = find(:all, :select => ('category, categoryname'), :conditions => ['tablename = ?',tablename], :order => "category")
    		result.each do |r|
    	  		category[r.category] = r.categoryname.downcase.split(/\s+/).join("_") rescue nil
    		end
    		return category
    	end

	def self.collect(options = {})
    	      find(:all, options)
        end


end

class Book < ActiveRecord::Base
    set_table_name "book"
    set_primary_key "code"

    def self.collect(options = {})
    	find(:all, options)
    end
  
end

class Article < ActiveRecord::Base
  set_table_name "articles"

  def self.collect(options = {})
     find(:all, options)
  end
end

class Articlelinks < ActiveRecord::Base
  set_table_name "articlelinks"

  def self.collect(options = {})
     find(:all, options)
  end
end

class NewArticles < ActiveRecord::Base
  set_table_name "articles_new"

  def self.collect(options = {})
     find(:all, options)
  end

  def self.migrate
    articles = Article.collect
    articles.each do |article|
      new_article = NewArticles.new(:URL => article.URL,
                                    :title => article.title,
                                    :editor => article.editor,
                                    :date_added => article.date_added,
                                    :keywords => article.keywords,
                                    :description => article.description,
                                    :iconname => article.iconname,
                                    :indexpage => article.indexpage,
                                    :maxicons => article.maxicons,
                                    :coltime => article.coltime,
                                    :ticker => article.ticker
                                    )
      file = ARTICLE_FILE_PATH + article.URL.split('.').join("body.")
      new_article.content = File.open(file, "r").read
      begin
        new_article.save!
      rescue Exception => e
        $articles_log.error("Article not saved, ERROR: #{e}")
      end
    end
  end
end

class NewArticlelinks < ActiveRecord::Base
  set_table_name "articlelinks_new"

  def self.migrate
    new_articles = {}
    NewArticles.collect(:select => "id,URL").collect{|a| new_articles[a.URL] = a.id}
    articlelinks = Articlelinks.collect
    articlelinks.each do |articlelink|
      new_articlelink = NewArticlelinks.new(:article_id => new_articles[articlelink.articlename],
                                            :linktype => articlelink.linktype,
                                            :url => articlelink.url,
                                            :image => articlelink.image,
                                            :title => articlelink.title,
                                            :writeup => articlelink.writeup,
                                            :display => articlelink.display,
                                            :name => articlelink.name,
                                            :email => articlelink.email
                                            )
      begin
        new_articlelink.save!
      rescue Exception => e
        $articlelinks_log.error("ArticleLink not saved: ERROR #{e}")
      end
    end
  end
end






MAIN_CATEGORIES={
			:paintings=>100,
			:sculptures=>200,
			:jewelry=>300,
			:beads=>400,
			:textiles=>500,
			:book=>600,
			:cds_dvds=>700,
			:ayurveda=>800,
                        :dolls=>900
		}


PAINTING_SUBCATEGORIES={
				:batik=>101,
				:folkart=>102,
				:hindu=>103,
				:large=>104,
				:marble=>105,
				:mughal=>106,
				:oils=>107,
				:persian=>108,
				:sikhart=>109,
				:tantra=>110,
				:thangka=>111,
				:wildlife=>112,
				:tanjore=>113
  		       }

SCULPTURE_SUBCATEGORIES={
				:brass=>201,
				:buddhist=>202,
				:dolls=>203,
				:hindu=>204,
				:large=>205,
				:nepalese=>206,
				:ritual=>207,
				:stone=>208,
				:tantra=>209,
				:wood=>210
			}

JEWELRY_SUBCATEGORIES={
				:anklets=>301,
				:bracelets=>302,
				:buddhist=>303,
				:earrings=>304,
				:fashion=>305,
				:gold=>306,
				:hindu=>307,
				:necklaces=>308,
				:pendants=>309,
			        :rings=>310,
				:sets=>311,
				:sterling_silver=>312,
				:stone=>313,
				:tantra=>314,
				:wholesale_lots=>315
   		      }

BEAD_SUBCATEGORIES={
				:"18_kt_gold"=>401,
				:faceted_gems=>402,
				:findings=>403,
				:gemstone=>404,
				:gold_plated=>405,
				:precious=>406,
				:sterling_silver=>407
		    }

TEXTILE_SUBCATEGORIES={	
				:bedspreads=>501,
				:carpets=>502,
				:fabrics=>503,
				:handbags=>504,
				:kurta_pajamas=>505,
				:ladies_tops=>506,
				:made_to_order=>507,
				:religious=>508,
				:salwar_kameez=>509,
				:saris=>510,
				:shawls=>511,
				:wholesale_lots=>512
		       }

BOOK_SUBCATEGORIES={
        :alternative_medicine=>601,
        :art_and_architecture=>602,
        :buddhist=>603,
        :comics=>604,
        :foreign_languages=>605,
        :hindu=>606,
        :history=>607,
        :indian_cinema=>608,
        :language_and_literature=>609,
        :performing_arts=>610,
        :philosophy=>611,
        :sociology_and_anthropology=>612,
        :tantra=>613,
        :travel=>614,
        :yoga=>615,
        :erotic=>616,
        :audio_video=>617
		   }

CD_DVD_SUBCATEGORIES={
        :bollywood=>701,
        :buddhist=>702,
        :children=>703,
        :culture=>704,
        :dance=>705,
        :discourses=>706,
        :dvd=>707,
        :folk=>708,
        :hindu=>709,
        :indian_classic_music=>710,
        :mp3=>711,
        :music_therapy=>712
                       }

AYURVEDA_SUBCATEGORIES={
				:baby_and_childcare=>801,
				:beauty_products=>802,
				:foods=>803,
				:health_and_medicine=>804,
				:herbs=>805,
				:oils=>805,
				:oral_care=>807,
				:species=>809,
				:teas_and_special_formulae=>810
			}

DOLLS_SUBCATEGORIES={
				:costume=>901,
				:barbie=>902,
				:puppets=>903,
				:hindu=>904
		    }

#AUDIO_VIDEO_SUBCATEGORIES={}
$logger=Logger.new('product_migrator_err.log')

class ProductMigrator 


	def migrating_product(ac_rec_obj)


       unless NewProduct.find_by_code(ac_rec_obj.code)
	     begin
		new_product=NewProduct.new
  		new_product.prod_height = ac_rec_obj.prod_height
  		new_product.prod_width = ac_rec_obj.prod_width
  		new_product.prod_length = ac_rec_obj.prod_length
  		new_product.length_unit = ac_rec_obj.length_unit
  		new_product.dimension = ac_rec_obj.dimension
  		new_product.prod_weight = ac_rec_obj.prod_weight
  		new_product.weight_unit = ac_rec_obj.weight_unit
  		new_product.weight_to_show = ac_rec_obj.weight_to_show
  		new_product.material = ac_rec_obj.material
		  new_product.frame = ac_rec_obj.frame
		  new_product.specialbuyer = ac_rec_obj.specialbuyer
      common_part_migrator_of_book_and_product(new_product,ac_rec_obj)
		  new_product.save
  puts "======="
   puts new_product.id
   puts "====="
      set_category(new_product, ac_rec_obj)
               
              rescue Exception=>e
                 puts("< #{ac_rec_obj.code} > product code not inserted")
	         $logger.error("Product not fetched : #{e}")
              end
           end
	end


       def common_part_migrator_of_book_and_product(new_product,ac_rec_obj)

            	new_product.code = ac_rec_obj.code
  		new_product.title = ac_rec_obj.title          
                new_product.category_id = Category.find(:first,:select=>'id',:conditions=>['name=?',ac_rec_obj.maincategory.downcase.strip]).id
  		# new_product.category = set_category(ac_rec_obj)

  		new_product.price = ac_rec_obj.price
                new_product.image_path = ac_rec_obj.URL
  		new_product.brief_comments = ac_rec_obj.brief_comments
		new_product.availability = ac_rec_obj.availability
		new_product.archive = ac_rec_obj.archive
		new_product.sold = ac_rec_obj.sold
		new_product.date_added = ac_rec_obj.date_added
		new_product.transid = ac_rec_obj.transid
		new_product.coltime = ac_rec_obj.coltime
	end

	def set_category(new_product,ac_rec_obj)
      
      subcat = []
      ac_rec_obj.category.split(",").each do |category| 
         category = MetaGenerator.find(:first,:conditions=>['category=? and tablename=?',
              category.strip,(ac_rec_obj.maincategory.downcase.strip rescue "book")],
              :select=>'categoryname')
         subcat << Subcategory.find(:first,:conditions=>['category_id=? and name=?',new_product.category,category.categoryname.strip]) unless (category.blank? and category.categoryname.blank?)
     end
    new_product.subcategories << subcat
	end	     		
end


