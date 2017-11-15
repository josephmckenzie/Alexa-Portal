require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'mail'
require_relative 'curl_requests.rb'
enable :sessions
load './local_env.rb' if File.exist?('./local_env.rb')

def authentication_required
	redirect to('/login') unless session[:user]
end

curl_requests = Curlrequests.new
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
	


	
	parsed = curl_requests.get_request
	
	erb :jonsays, :locals => {:currentsaying => parsed}
end


post '/jonsays' do

	saying = params[:saying]
  curl_requests.post_request(saying)
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

get '/login' do
	invalid = params[:invalid] || ''
	erb :login, :locals => {:message => "", :invalid => invalid}
end


post '/login' do
	user_email = params[:form_email]
	user_password = params[:form_password]
#	db = connection()
#	sql = "SELECT email, password FROM admin_users WHERE email = '#{user_email}'"
#	user = db.exec(sql)
#
#	if user.num_tuples.zero?
#		redirect '/login?invalid=Invalid Email or Password'
#	end
#
#	begin
#		db_pass = user[0]['password']
#		pass = BCrypt::Password.new(db_pass)
#	rescue BCrypt::Errors::InvalidHash
#		redirect '/login?invalid=Invalid Email or Password'
#	end 


#	db_pass = user[0]['password']
#	pass = BCrypt::Password.new(db_pass)

	if ENV['password'] != user_password || ENV['username'] != user_email
		redirect '/login?invalid=Invalid Email or Password'
	else
		session[:user] = user_email
		redirect to '/admin'
		db.close
	end
end

get '/admin' do
		authentication_required
	parsed = curl_requests.get_request
	
	
	erb :admin, :locals => {:currentsaying => parsed}

end

get '/deletephrase' do
	
	id = params[:id]
	 curl_requests.delete_request(id)
	
	redirect 'admin'
end

get '/logout' do
	session[:user] = nil
	redirect '/'
end