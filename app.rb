require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

def get_db 
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" 
			(	"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
				"username" TEXT, 
				"phone" TEXT,
				"datestamp" TEXT,
				"barber" TEXT,
				"color" TEXT 
			)'
			
	db.execute 'CREATE TABLE IF NOT EXISTS "barber" 
			(	"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
				"name" TEXT
			)'

end

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


# multiple validation msg
	def get_validation_msg 
		
		hh ={ :username => "name i required",
		 	   :phone =>    "phone is required",
		 	   :datetime => "date is required"
			}

		@error = hh.select {|key,_| params[key] == ""}.values.join(" , ")
	end

	if get_validation_msg  != ''
		return erb :visit
	end

# f = File.open "public/users.txt", "a"  #а дописуємо в кінець файлу
# 	f.write "Customer : #{@username} , #{@phonenum},  when: #{@datetime} \n\t worker: #{@worker} , hair color: #{@color} \n"
# 	f.close		

	db = get_db
	db.execute 'INSERT INTO Users (username, phone, datestamp, barber, color) 
				VALUES (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @worker, @color]
	db.close


 	erb "Thank you <b>#{@username.capitalize}</b>, we will contact with you ASAP"
end




#--------contact------

post '/contacts' do
  # @mail = params[:email]   
  # @msg   = params[:message]

# Pony.mail({
#   :to => 'bender2019@ukr.net',
#   :from => params[:email], 
#   :subject => 'hi', 
#   :body => params[:message],
#   :via => :smtp,
#   :via_options => {
#     :address        => 'smtp.ukr.net',
#     :port           => '2525',
#     :enable_starttls_auto => true,
#     :user_name      => 'bender2019',
#     :password       => 'K440V7*is7',
#     :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
#     :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
#   }
# })


# Pony.options = { :from => 'noreply@example.com', 
# 				 :via => :smtp, 
# 				 :via_options => { 
# 				 	:address => 'smtp.ukr.net', 
# 				    :port          => '2525',
# 			        :enable_starttls_auto => true,
# 			        :user_name      => 'bender2019',
# 			      	:password       => 'K440V7*is7',
# 			      	:authentication => :plain, # :plain, :login, :cram_md5, no auth by default
# 			      	:domain         => "localhost:4567.localdomain"
# 			    	}
# 	      		} 

# Pony.mail(:to => 'bender2019@ukr.net') # Sends mail to bender2019@ukr.net from noreply@example.com using smtp



 #  f = File.open "public/contacts.txt", "a"  #а дописуємо в кінець файлу
 # 	f.write "USER-mail : #{@mail} ,message: #{@msg} \n"
 # 	f.close		

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

get '/showusers' do
 
	db = get_db
	@results = db.execute 'SELECT * FROM Users order by id desc' 

	erb :showusers

end