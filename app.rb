require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/other' do
	erb :other
end

post '/visit' do
	@username = params [:username]
	@phonenum = params [:phone]
	@datetime = params [:datetime]
#	@barbermaster = params[barbermaster]


	f = File.open "users.txt", "a"  #а дописуємо в кінець файлу
 	f.write "Customer : #{@username} , #{@phonenum},  when: #{@datetime} \n"
 	f.close		

 	erb "Thank you, we will contact with you ASAP"

end