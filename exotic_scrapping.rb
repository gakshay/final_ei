require 'rubygems'
require 'net/http'
require 'uri'

HOST = "http://exoticindia.com"
USERAGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.99 Safari/533.4"

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
