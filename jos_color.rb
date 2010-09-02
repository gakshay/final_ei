require 'rubygems'
require 'net/http'
require 'uri'
require 'jos_models'
require 'jos_category_constant'

HOST = "http://www.exoticindia.com"
USERAGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.99 Safari/533.4"

ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :username => "root",
            :database => "clearsenses_v4"
					)
$log = Logger.new('color.log')

COLOR_FILE_PATH = "/home/akshay/Projects/final_ei/color_url.txt"

class ColorScapping
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
class ProductColor
  def initialize
    @products = {}
    products = JosVmProduct.all.each{|pro| @products[pro.product_sku] = pro.product_id }
    @file = File.open(COLOR_FILE_PATH, "r")
    @robot = ColorScapping.new
  end
  
  def populate
    File.open(COLOR_FILE_PATH, "r") do |line|
      while (data = line.gets)
        $log.info("***********#{data}")
        link, c, s, p = separate_csp(data)
        jos_color = get_jos_color(c,s,p)
        skus = @robot.fetch(link)
        unless skus.blank? and jos_color.blank?
          $log.debug("SKUS: #{skus.join(", ")}")
          products = read_products_from_sku(skus)
          $log.debug("products: #{products.length}") unless products.blank?
          jos_color.jos_vm_product << products unless products.blank?
        end
      end
    end
  end

  def separate_csp(data)
    data = data.split(/\s+/)
    link = data[0]
    invalue = link.gsub("http://www.exoticindia.com/","").split(/\//)
    c = invalue[data.index("Category")-1] rescue nil
    s = invalue[data.index("SubCate")-1] rescue nil
    p = invalue[data.index("Color")-1] rescue nil
    return link + "xmllist", c, s, p 
  end

  def read_products_from_sku(skus)
    ids = []
    skus.each do |sku|
      ids  << @products[sku] unless @products[sku].blank?
    end
    ids.compact
    puts ids.inspect
    products = JosVmProduct.find ids
    return products
  end

  def get_jos_color(c,s, p)
    subcategory_id = MAP1[CATHASH[c]].select{|sc| sc if MAP2[sc][0].gsub(/\s+/,"").downcase == s.downcase }
    puts subcategory_id
    jos_color = JosColor.find_or_create_by_color_and_subcategory_id(p, subcategory_id[0])
    puts "=============================="
    puts jos_color.inspect
    return jos_color
  end
end
