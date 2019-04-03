require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = "somehing wrong..."
	erb :about
end

get '/visit' do
	erb :visit
end

get '/other' do
	erb :other
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phonenum = params[:phone]
	@datetime = params[:datetime]
	@worker   = params[:barber]
	@color	  = params[:color] 
	
if @username == ''
	@error = 'name is required'
	return erb :visit
end



	f = File.open "public/users.txt", "a"  #а дописуємо в кінець файлу
 	f.write "Customer : #{@username} , #{@phonenum},  when: #{@datetime} \n\t worker: #{@worker} , hair color: #{@color} \n"
 	f.close		

 	erb "Thank you <b>#{@username.capitalize}</b>, we will contact with you ASAP"
end

post '/contacts' do
 @mail = params[:email]   
 @msg   = params[:message]

	f = File.open "public/contacts.txt", "a"  #а дописуємо в кінець файлу
 	f.write "USER-mail : #{@mail} ,message: #{@msg} \n"
 	f.close		

 	erb "Thank you for the msg"
end

#--------admin part------
get '/admin' do
	erb :login_form
end

post '/admin' do
	@login 	= params[:username]
	@pass	= params[:password]

	if @login == 'admin' && @pass == 'admin'
 		send_file 'public/users.txt'
 #		send_file 'public/contacts.txt'
	 	erb :login_form
	else
		@denied = "Wrong credential, access denied"
		erb :login_form
	end
end

#commit