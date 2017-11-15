require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

get '/jonsays' do
	#You can do curl requests in a few different ways in Ruby this is an example using backticks to do a simple curl request, Here we are getting the current list of what Jon says.
	currentsaying = `curl -X GET https://bsi7688wf2.execute-api.us-east-1.amazonaws.com/dev/todos`
	parsed = JSON.parse(currentsaying)
	erb :jonsays, :locals => {:currentsaying => parsed}
end


post '/jonsays' do

	saying = params[:saying]
	#this is another way to make your curl requests in Ruby , Here we are using the net/http gem to make a post request to post a new Jon Says.
	uri = URI.parse("https://bsi7688wf2.execute-api.us-east-1.amazonaws.com/dev/todos")
	request = Net::HTTP::Post.new(uri)
	request.content_type = "application/json"
	request.body = JSON.dump({
		"text" => "#{saying}"
		})
	req_options = {
		use_ssl: uri.scheme == "https",
		}
	response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		http.request(request)
	end
redirect 'jonsays'
end