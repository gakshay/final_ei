require 'rubygems'
require 'net/http'
require 'uri'
require 'exotic_models'

HOST = "http://exoticindia.com"
USERAGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.99 Safari/533.4"

$log = Logger.new('server.log')

FILE_PATH = "/home/akshay/Projects/final_ei/url.txt"

class ExoticScapping
	def initialize
		@headers = {"Content-Type" => "text/html", "charset" => "utf-8", 'User-Agent' => USERAGENT}
		url = URI.parse HOST 
		@http = Net::HTTP.new(url.host, url.port)
		resp, data = @http.get("/in", @headers)
		@cookie = resp.response['set-cookie'].split("; ")[0]	
	end 

	def fetch (url)
	  path = url.gsub(HOST,"")
		resp, data = @http.get(path, @headers.merge('Cookie' => @cookie))
		return data.split(/\n/)
	end
end

#script
class ProductSpecialSubcategory 
  def initialize
    @products = {}
    products = Product.find(:all, :select => "id, code").each{|pro| @products[pro.code] = pro.id }
    @categories = {}
    Category.find(:all, :select => "id, name").each{|a| @categories[a.name] = a.id }
    @sub_categories = {}
    Subcategory.find(:all, :select => "id, name, category_id").each{|a| @sub_categories["#{a.name.gsub(/\s/,'')}_#{a.category_id}"] = a.id }
    @special_subcategories = {}
    SpecialSubcategory.find(:all, :select => "id, filename, subcategory_id").each{|a| @special_subcategories["#{a.filename.gsub(/\s/,'')}_#{a.subcategory_id}"] = a.id }
    @file = File.open(FILE_PATH, "r")
    @robot = ExoticScapping.new
  end
  
  def populate
    File.open(FILE_PATH, "r") do |line|
      while (data = line.gets)
        $log.info("***********#{data}")
        link, c, s, p = separate_csp(data)
        skus = @robot.fetch(link)
        unless skus.blank?
          $log.debug("SKUS: #{skus.join(", ")}")
          products = read_products_from_sku(skus)
          $log.debug("Products found: #{products.collect(&:id).join(", ")}")
          special_subcategory = get_special_subcategory(c,s,p)
          $log.debug("Special Subcategory: #{special_subcategory.id}")
          special_subcategory.products << products unless special_subcategory.blank?
        end
      end
    end
  end

  def separate_csp(data)
    data = data.split(/\s/)
    link = data[0]
    invalue = link.gsub("http://exoticindia.com/","").split(/\//)
    c = invalue[data.index("C")-1] rescue nil
    s = invalue[data.index("S")-1] rescue nil
    p = invalue[data.index("P")-1] rescue nil
    return link + "xmllist", c, s, p 
  end

  def read_products_from_sku(skus)
    ids = []
    skus.each do |sku|
      ids  << @products[sku]
    end
    products = Product.find(:all, :conditions => ['id in (?)', ids.compact])
    return products
  end

  def get_special_subcategory(c,s,p)
    category_id = @categories[c]
    $log.debug("Category id : #{category_id}")
    subcategory_id = @sub_categories["#{s}_#{category_id}"]
    $log.debug("Sub Category id : #{subcategory_id}")
    ssid = @special_subcategories["#{p}_#{subcategory_id}"]
    special_subcategory = SpecialSubcategory.find_by_id ssid
    return special_subcategory
  end
end


