require 'net/http'
require 'uri'
require 'json'
#
class Curlrequests
		
		def post_request(jonsays,skill,personsname,shotname)

		
				#this is another way to make your curl requests in Ruby , Here we are using the net/http gem to make a post request to post a new Jon Says.
		uri = URI.parse("https://bsi7688wf2.execute-api.us-east-1.amazonaws.com/dev/todos")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request.body = JSON.dump({
			"jonsays" => jonsays,
			"skill" => skill,
			"personsname" => personsname,
			"shotname" => shotname
			})
		req_options = {
			use_ssl: uri.scheme == "https",
			}
		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			http.request(request)
		end
	response.code
	end

def get_request()

		
				#this is another way to make your curl requests in Ruby , Here we are using the net/http gem to make a post request to post a new Jon Says.
		uri = URI.parse("https://bsi7688wf2.execute-api.us-east-1.amazonaws.com/dev/todos")
		request = Net::HTTP::Get.new(uri)
		request.content_type = "application/json"
#		request.body = JSON.dump({
#			"text" => "#{saying}"
#			})
		req_options = {
			use_ssl: uri.scheme == "https",
			}
		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			http.request(request)
		end
	parsed = JSON.parse(response.body)
	

#  puts response.code
	
	end

def delete_request(id)

				#this is another way to make your curl requests in Ruby , Here we are using the net/http gem to make a post request to post a new Jon Says.
		uri = URI.parse("https://bsi7688wf2.execute-api.us-east-1.amazonaws.com/dev/todos/" +id)
		request = Net::HTTP::Delete.new(uri)
		request.content_type = "application/json"
#		request.body = JSON.dump({
#			"text" => "#{saying}"
#			})
		req_options = {
			use_ssl: uri.scheme == "https",
			}
		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			http.request(request)
		end
	parsed = JSON.parse(response.body)
	

#  puts response.code
	
	end




end
		
