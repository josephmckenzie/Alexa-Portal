require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'mail'
load './local_env.rb' if File.exist?('./local_env.rb')

options = { :address              => "smtp.gmail.com",
	:port                 => 587,
	:domain               => ENV['domain'],
	:user_name            => ENV['email'],
	:password             => ENV['email_pass'],
	:authentication       => 'plain',
	:enable_starttls_auto => true  }

Mail.defaults do
	delivery_method :smtp, options
end



get '/' do

	erb :index
	
end



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

get '/whoseshot' do

	erb :whoseshot

end

post '/whoseshot' do
	
	redirect 'whoseshot'
end

get '/contact'do
	#allows protection against robot spammers
	thanks = params[:thanks] || ''
	num1 = rand(9)
	num2 = rand(9)
	sum = num1 + num2
	deliver = params[:deliver] || ''
	messages = {'' => '', 'success' => "Thank you for your message. We'll get back to you shortly.", 'error' => 'Sorry, there was a problem delivering your message.'}
	message = messages[deliver]

	erb :contact, :locals => {thanks: thanks, num1: num1, num2: num2, sum: sum, message: message }
end

post '/contact' do

	name = params[:name]
	phone = params[:phone]
	email = params[:email]
	message = params[:message]
	reason = params[:reason]
	sum = params[:sum]
	robot = params[:robot]
	
	email_body = erb :emailcontact, :layout => false, locals: {name: name, phone: phone, email: email, message: message, reason: reason }
	if robot == sum

		Mail.deliver do
			from      "#{email}"
			to        "joseph.p.mckenzie84@gmail.com"
			subject   "Contact Message for '#{reason}'"
			content_type 'text/html; charset=UTF-8'
			body      email_body
		end

		redirect '/contact?deliver=success'
	else
		redirect '/contact?deliver=error'
	end
end
