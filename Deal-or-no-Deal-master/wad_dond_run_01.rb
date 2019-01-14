#Sources:

#Rspec file, class structure and basic methods for gen file and run file of the DOND game:
#Author: Nigel Beacham
#Date: provided for further use in the assignment in March 2018
#Title:  wad_dond_01.zip
#Code version: not provided
#Type: Source code
#Web address/Publisher: Dr. Nigel Beacham, University of Aberdeen

#Sinatra gem
#Author: Blake Mizerany
#Date: May 07, 2017 (for version 2.0.0)
#Title: Sinatra
#Code version: 2.0.0
#Type: Ruby gem
#Web address: www.sinatrarb.com

#Activerecord/sinatra gem
#Author: Blake Mizerany
#Date: May 21, 2012 (latest commit)
#Title: Sinatra ActiveRecord Extension
#Code version: 2.0.13
#Type: Ruby gem
#Web address: https://github.com/bmizerany/sinatra-activerecord

#Bcrypt gem
#Author: Coda Hale
#Date: May 2017 (latest commit)
#Title: Bcrypt
#Code Version: 3.1.11
#Type: Ruby gem
#Web address: https://github.com/codahale/bcrypt-ruby

#FileUtils gem
#Author: Minero Aoki
#Date: December 12, 2017
#Title: FileUtils
#Code Version: 1.0.2
#Type: Ruby gem
#Web address: https://rubygems.org/gems/fileutils/versions/0.7.2

#Delete contents from file
#Author: Tamer Shlash
#Date: April 2, 2015
#Code version: ---
#Type: Source code
#Web address: https://stackoverflow.com/questions/3815979/delete-all-the-content-from-file

#How to process lines in a file
#Author: Alvin Alexander
#Date: July 23, 2016
#Code version: ----
#Type: Source code
#Web address: https://alvinalexander.com/blog/post/ruby/how-process-line-text-file-ruby

#How to sort an array of strings with integers
#Author: user Jan E.
#Date: March 27, 2013
#Code version: ---
#Type: Source Code
#Web address: https://www.ruby-forum.com/topic/3940438

#Cheat sheet for Ruby arrays
#Author: ShortcutFoo
#Date: not provided
#Code version: not provided
#Type: List
#Web address: https://www.shortcutfoo.com/app/dojos/ruby-arrays/cheatsheet

#Apart from these sources, the official Ruby documentation was consulted for different information. 
#Different web pages host the documentation, which can be found by searching for “ruby documentation” on a search engine.



# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'pp'
require 'fileutils'

enable :sessions
set :logging, :true

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_dond_gen_01"

# Main program
module DOND_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	box = 0
	turn = 0
	win = 0
	deal = 0
	@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
	@output.puts "\n" + 'Enter "1" runs game in command-line window or "2" runs it in web browser.' + "\n"
	@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
	game = @input.gets.chomp
	if game == "1"
		@output.puts "\nCommand line game.\n"
	elsif game == "2"
		@output.puts "\nWeb-based game.\n"
	else
		@output.puts "\nInvalid input! No game selected.\n"
		exit
	end
		
if game == "1"
	# Any code added to command line game should be added below.

	#see gen file for comments on what the methods do. This code uses the methods from the gen file
	#and the comments will focus on explaining the loop structure. See citations for sources at the very beginning of this file and in 
	#the report file.
	g.start				# calls start method 
	g.resetgame
	g.assignvaluestoboxes
	g.newline
	g.showamounts
	g.displaychosenboxprompt
	g.setchosenbox(g.getinput.to_i)
	#checks if input is between 1 and 22 and prompts user again if it is not
	while g.getchosenbox.between?(1, 22) == false
	break if g.getchosenbox.between?(1, 22) == true
		g.displaychosenboxerror
		g.displaychosenboxprompt
		g.setchosenbox(g.getinput.to_i)
	end
	g.getchosenbox
	g.displaychosenbox
	
	round_count = 0 #this variable is used to reiterate the for loop below for the correct number of times
	while true do #all of the game code is inside one big while loop
		g.displaymenu
		choice = g.getinput
		if choice == "1"
			if g.unopenedboxesleft == 1 #checks if a game has been played previously and there is only one unopened box left (prvious chosen box)
				@output.puts "It seems that a game has just been played! Choose '2' in the menu to start a new game. \nPress Enter to go back to the menu."
				choice = g.getinput
				next 
			end
			#the for loop iterates between the current value of round_count and 19. round_count is used instead of a fixed Integer,
			#because otherwise, when a player goes back to the menu and then wants to continue playing the for loop would start
			#from the fixed Integer again, instead of only repeating for the remaining turns left. As round_count adds +1 every
			#time one round is completed, it is ensured that the for loop does not iterate more than 20 times in total
			for @turn in (round_count..19) do #this loop iterates through the box opening process 20 times, until there are only two boxes left
				g.showboxes
				g.newline
				g.showamounts
				g.newline
				g.newline
				g.displayselectboxprompt     #Start
				choice = g.getinput.to_i
				ind = choice - 1 
				#allows player to go back to the menu if they press enter.
				# =0 because anything that is not an Integer (e.g. \n) and gets set .to_i is 0
				if choice == 0
					@turn = 20
					break
				end

				#This while loop is used to ensure that the player enters a valid value when prompted to open a box.
				#The value needs to be between 1 and 22, different to the box chosen in the beginning and different to
				#the value of already opened boxes. As long as these conditions are not met, the player gets prompted
				#with an error message and is asked to correct his input.

				while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1
					while choice == g.getchosenbox
						#puts "a"
						g.openedboxnotuniqueerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while choice.between?(1, 22) == false
						#puts "b"
						break if choice.between?(1, 22) == true
						g.displaychosenboxerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while g.checkbox(ind) == 1 #== false###
						#puts "c"
						#puts g.checkbox(ind)
						break if g.checkbox(ind) == 0 #== true###
						g.openedboxeserror###
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
				end
				g.boxvalid(g.getchosenbox)
				g.openboxes(choice.to_i)
				g.removeamounts(choice.to_i)
				g.storeguess(choice)
				g.showselectedboxes
				g.setopenedbox(choice)
				g.displayopenedboxvalue
				g.bankercalcsoffer
				g.bankerphoneswithoffer
				g.dealornodeal
				choice = g.getinput
				#gives error if player enters anything than Y or N and only breaks if he does
				while choice != "Y" || choice != "N"
				break if choice == "Y" or choice == "N"
					g.selectdealornodeal
					g.dealornodeal
					choice = g.getinput
				end
				if choice == "Y"
					g.makedeal
					#iterates rounds (without banker offer) until only two boxes are unopened
					until g.unopenedboxesleft == 2 do
						g.displayselectboxprompt 
						choice = g.getinput.to_i
						ind = choice - 1 

						while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box cant be box you chose and cant be between 1 and 22
							while choice == g.getchosenbox
								g.openedboxnotuniqueerror
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
							while choice.between?(1, 22) == false
								break if choice.between?(1, 22) == true
								g.displaychosenboxerror
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
							while g.checkbox(ind) == 1 #== false###
								break if g.checkbox(ind) == 0 #== true###
								g.openedboxeserror###
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
						end
						g.boxvalid(g.getchosenbox)
						g.openboxes(choice.to_i)
						g.removeamounts(choice.to_i)
						g.storeguess(choice)
						g.showselectedboxes
						g.setopenedbox(choice)
						g.displayopenedboxvalue
						g.incrementturn
						g.incrementloop
						g.getturnsleft
						g.newline
						g.showboxes 
						g.newline
						g.newline
						g.showamounts
						g.newline
					end
					#the following part handles the opening of the final two boxes when the player took a deal
					g.finaltwoboxesdealtaken
					g.displayselectboxprompt
					choice = g.getinput.to_i
					ind = choice - 1 
					while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box cant be box you chose and cant be between 1 and 22
						while choice == g.getchosenbox
							g.openedboxnotuniqueerror
							g.displayselectboxprompt
							choice = g.getinput.to_i
							ind = choice - 1 
						end
						while choice.between?(1, 22) == false
							break if choice.between?(1, 22) == true
							g.displaychosenboxerror
							g.displayselectboxprompt
							choice = g.getinput.to_i
							ind = choice - 1 
						end
						while g.checkbox(ind) == 1 #== false##
						break if g.checkbox(ind) == 0 #== true###
							g.openedboxeserror###
							g.displayselectboxprompt
							choice = g.getinput.to_i
							ind = choice - 1 
						end
					end
					g.boxvalid(g.getchosenbox)
					g.openboxes(choice.to_i)
					g.removeamounts(choice.to_i)
					g.storeguess(choice)
					g.showselectedboxes
					g.setopenedbox(choice)
					g.displayopenedboxvalues
					g.displaychosenboxvaluedeal
					g.finaldealmessage
					@output.puts "Press Enter to go back to menu."
					g.getinput 
					@turn = 20
					break #redirects back to menu
				end# End of the if clause 
				if round_count == 19 #breaks out of the for loop after the 20th iteration (starting from 0)
					break
				end
				round_count += 1 #adds 1 to the round counter at the very end of the for loop
			end
			if @turn == 20
				g.loopbreaker #if @turn is already 20, the final two boxes have already been opened, so the player gets redirected to the menu
			else #otherwise, the final two boxes part gets executed at this point
				g.finaltwoboxes
				g.showboxes
				g.newline
				g.showamounts
				g.newline
				g.newline
				g.displayselectboxprompt
				choice = g.getinput.to_i
				ind = choice - 1 
				while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box cant be box you chose and cant be between 1 and 22
					while choice == g.getchosenbox
						g.openedboxnotuniqueerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while choice.between?(1, 22) == false
						break if choice.between?(1, 22) == true
						g.displaychosenboxerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while g.checkbox(ind) == 1 #== false##
					break if g.checkbox(ind) == 0 #== true###
						g.openedboxeserror###
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
				end
				g.boxvalid(g.getchosenbox)
				g.openboxes(choice.to_i)
				g.removeamounts(choice.to_i)
				g.storeguess(choice)
				g.showselectedboxes
				g.setopenedbox(choice)
				g.displayopenedboxvalue
				g.displaychosenboxvalues
				g.finish
				@output.puts "Press enter to go back to menu."
				g.getinput
				g.loopbreaker#
			end
		elsif choice == "2"				#starts with resetting the game and assigning new values to the boxes
			round_count = 0				#resets round_count to 0 
			g.resetgame
			g.assignvaluestoboxes
			g.newline
			g.showamounts
			g.displaychosenboxprompt #lets player choose a new box as his own
			g.setchosenbox(g.getinput.to_i)
			while g.getchosenbox.between?(1, 22) == false
			break if g.getchosenbox.between?(1, 22) == true
				g.displaychosenboxerror
				g.displaychosenboxprompt
				g.setchosenbox(g.getinput.to_i)
			end
			g.getchosenbox
			g.displaychosenbox
			for @turn in (round_count..19) do #from here on, the code executed is similar to the loops above
				g.showboxes
				g.newline
				g.showamounts
				g.newline
				g.newline
				g.displayselectboxprompt     
				choice = g.getinput.to_i
				ind = choice - 1 

				if choice == 0
					@turn = 20
					break
				end
				while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box can't be box you chose and cant be between 1 and 22
					while choice == g.getchosenbox
						g.openedboxnotuniqueerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while choice.between?(1, 22) == false
						break if choice.between?(1, 22) == true
						g.displaychosenboxerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while g.checkbox(ind) == 1 #== false###
						break if g.checkbox(ind) == 0 #== true###
						g.openedboxeserror###
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
				end
				g.boxvalid(g.getchosenbox)
				g.openboxes(choice.to_i)
				g.removeamounts(choice.to_i)
				g.storeguess(choice)
				g.showselectedboxes
				g.setopenedbox(choice)
				g.displayopenedboxvalue
				g.bankercalcsoffer
				g.bankerphoneswithoffer
				g.dealornodeal
				choice = g.getinput
				while choice != "Y" || choice != "N"
				break if choice == "Y" or choice == "N"
					g.selectdealornodeal
					g.dealornodeal
					choice = g.getinput
				end
				if choice == "Y"
					g.makedeal
					#continue at displayselectboxprompt
					until g.unopenedboxesleft == 2 do#########################deal loop
						g.displayselectboxprompt     #Start
						choice = g.getinput.to_i
						ind = choice - 1 
						while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box cant be box you chose and cant be between 1 and 22
							while choice == g.getchosenbox
								g.openedboxnotuniqueerror
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
							while choice.between?(1, 22) == false
								break if choice.between?(1, 22) == true
								g.displaychosenboxerror
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
							while g.checkbox(ind) == 1 #== false###
								break if g.checkbox(ind) == 0 #== true###
								g.openedboxeserror###
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
						end
						g.boxvalid(g.getchosenbox)
						g.openboxes(choice.to_i)
						g.removeamounts(choice.to_i)
						g.storeguess(choice)
						g.showselectedboxes
						g.setopenedbox(choice)
						g.displayopenedboxvalue
						g.incrementturn
						g.incrementloop
						g.getturnsleft
						g.newline
						g.showboxes 
						g.newline
						g.newline
						g.showamounts
						g.newline
					end
					####################final two boxes part
						g.finaltwoboxesdealtaken
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
						while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box cant be box you chose and cant be between 1 and 22
							while choice == g.getchosenbox
								g.openedboxnotuniqueerror
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
							while choice.between?(1, 22) == false
								break if choice.between?(1, 22) == true
								g.displaychosenboxerror
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
							while g.checkbox(ind) == 1 #== false##
							break if g.checkbox(ind) == 0 #== true###
								g.openedboxeserror###
								g.displayselectboxprompt
								choice = g.getinput.to_i
								ind = choice - 1 
							end
						end
						g.boxvalid(g.getchosenbox)
						g.openboxes(choice.to_i)
						g.removeamounts(choice.to_i)
						g.storeguess(choice)
						g.showselectedboxes
						g.setopenedbox(choice)
						g.displayopenedboxvalues
						g.displaychosenboxvaluedeal
						g.finaldealmessage
						g.finish
						@output.puts "Press Enter to go back to menu."
						g.getinput 
						@turn = 20
						break ###############get back to menu
				end############################## END of IF CHOICE = "DEAL"
				if round_count == 19
					break
				end				
				round_count += 1
			end
			if @turn == 20
				g.loopbreaker
			else
				g.finaltwoboxes
				g.showboxes
				g.newline
				g.showamounts
				g.newline
				g.newline
				g.displayselectboxprompt
				choice = g.getinput.to_i
				ind = choice - 1 
				while choice == g.getchosenbox || choice.between?(1, 22) == false || g.checkbox(ind) == 1 #box cant be box you chose and cant be between 1 and 22
					while choice == g.getchosenbox
						g.openedboxnotuniqueerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while choice.between?(1, 22) == false
						break if choice.between?(1, 22) == true
						g.displaychosenboxerror
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
					while g.checkbox(ind) == 1 #== false##
					break if g.checkbox(ind) == 0 #== true###
						g.openedboxeserror###
						g.displayselectboxprompt
						choice = g.getinput.to_i
						ind = choice - 1 
					end
				end
				g.boxvalid(g.getchosenbox)
				g.openboxes(choice.to_i)
				g.removeamounts(choice.to_i)
				g.storeguess(choice)
				g.showselectedboxes
				g.setopenedbox(choice)
				g.displayopenedboxvalue
				g.displaychosenboxvalues
				g.finish
				@output.puts "Press enter to go back to menu."
				g.getinput
				g.loopbreaker
			end
		elsif choice == "3" #shows status of all boxes (opened or closed) and allows player to go back to menu afterwards
			g.displayanalysis
			@output.puts "Press enter to go back to menu."
			g.getinput
			#g.loopbreaker #doesnt actually do anything because the @loops are different variables
		elsif choice == "9" #exits program
			exit
		else @output.puts "\nInvalid input! No game selected.\n"
		end
	end
	g.finish				# calls finish method
		
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
end
end


# End modules

# Sinatra routes
	# Any code added to web-based game should be added below.

#Creates a class Web_Game which inherits the contents of the Class game under the module DOND_Game
class Web_Game < DOND_Game::Game
end

#Points the Base class under ActiveRecord to which method it should use to make the connection between the database and the webapplication and the name of the database file
ActiveRecord::Base.establish_connection(
 :adapter => 'sqlite3',
 :database => 'dond.db'
)


#Creates a class User which inherits ActiveRecord::Base and is used to direct ActiveRecord which tables are required and what characteristics they should have; :password is encrypted by bcrypt
class User < ActiveRecord::Base
 validates :username, presence: true, uniqueness: true
 has_secure_password 
end

#Creates a global variable which represents an instance of the Web_Game which initialises @input and @output
$webgame = Web_Game.new(@input, @output)

helpers do
	def protected! #problem: authorizes any user that has edit rights to access admin controls through URL, so essentially only two authentication levels: normal user, admin.
        if authorized? #solution: see below
            return
        end
    redirect '/denied'
    end

    def authorized?
        if $credentials != nil
            @Userz = User.where(:username => $credentials[0]).to_a.first
            if @Userz
                if @Userz.edit == true
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    end


	#adminprotected adds another layer of authentication, so that only the user with
	#the username "Admin" is allowed to enter areas that are protected with 
	#adminprotected! It checks if the user is authorized (like in the "normal"
	#protected! routine) and if the user is an admin. This check is performed
	#in the helper isuseradmin. If the curent users username is "Admin", it returns
	#true and if not it returns false. Consequently, adminprotected! returns false
	#if the users name is not "Admin". This is a workaround and only allows 1 real
	#administrator, which is "Admin".

    def adminprotected!
        if authorized? == true and isuseradmin? == true
            return
        else redirect '/denied'
        end
    end

	#isuseradmin checks if the currently logged in user has the username "Admin"
    def isuseradmin?
        if $credentials != nil
            isadminornot = User.where(:username => $credentials[0]).to_a.first
            @adminuser = "#{isadminornot.username}"
            if @adminuser == "Admin"
                return true
            else 
                return false
            end
        end 
    end
end


#Displayes the home.erb file
get '/' do
	erb:home
end

#Displays the continue page which is protected to be accessed only by users logged in 
#and redirects the user depending wether they have taken the deal or not to the appropriate page
get '/continue' do
	protected!
	if $dealtakenornot == true
		redirect '/deal'
	else
		redirect '/openboxes'
	end
end

#Displayes the new game page and resets the varaibles and assigns values to boxes
get '/new' do
	protected!
	$webgame.webresetgame
	$webgame.assignvaluestoboxes
	erb:new
end

#Displays the log page and initiates the creation of an entry for the viewing of the log file.
get '/log' do
	protected!
	$webgame.updateLogFile("Viewlog")
    logfile = []
    file = File.open("log.txt")
    file.each do |line|
        logfile << line
    end
    file.close
    @logfile = logfile
    erb:log
end

#Displays the logreset page and clears the entries from the log.txt file
get '/logreset' do
	adminprotected!
	File.truncate("log.txt", 0) # the reset process was implemented adapting the information found in the following stackoverflow q/a: https://stackoverflow.com/questions/3815979/delete-all-the-content-from-file
	erb:logreset
end

#Updates the value of the @chosenbox variable and displays the displaychosenbox page
post '/displaychosenbox' do
	input = params[:message].to_i
	$webgame.chosenbox = input
	erb:displaychosenbox
end

#Dislplays the page that contains the main part of the game which is also protected to display only for logged in users
get '/openboxes' do
	protected!
	erb:openboxes
end

#Sends the input from the forms which represent the boxes' numbers and checks in an if-clause if it should enter the last phase of the game,
#Otherwise changes the contents of the arrays and retrieves the values needed for the banker offer as well as the strings needed to display certain messages on-screen
put '/openboxes' do
	$webgame.incrementturn
	input = params[:message].to_i
	$webgame.input = input
	if $webgame.openedboxes.count(0) == 3
			$webgame.webopenboxes(input)
			$webgame.storeguess(input)
			$webgame.removeamounts(input)
			$webgame.webdisplayopenedboxvalue
			$webgame.bankercalcsoffer
			$webgame.webbankerphoneswithoffer
			redirect '/twoboxes'
		else
			nil
	end
	$webgame.webopenboxes(input)
	$webgame.storeguess(input)
	$webgame.removeamounts(input)
	$webgame.webdisplayopenedboxvalue
	$webgame.bankercalcsoffer
	$webgame.webbankerphoneswithoffer
	$webgame.retrievedealvalue
	erb:openboxes
end

#Displays the deal page, retrieves the deal value and updates the log.txt file
get '/deal' do
	protected!
	$webgame.retrievedealvalue
	$webgame.displaydealvalue
	$webgame.updateLogFile("Deal")
	$webgame.updateScoreFile("Deal")
	erb:deal
end

#Saves, retrieves and sends the values needed to change the objects in the arrays involved in the part of the game where the deal has been taken 
put '/deal' do
	$webgame.webopenboxes(params[:message].to_i)
	$webgame.storeguess(params[:message].to_i)
	$webgame.removeamounts(params[:message].to_i)
	$webgame.webdisplayopenedboxvalue
	erb :deal
end

#Displays the displayanalysis page and retrieves the data needed using the webdisplayanalysis method
get '/displayanalysis' do
	protected! 
	$webgame.webdisplayanalysis
	erb:displayanalysis
end

#Displays the twoboxes page, which is loaded when there are two values left in the @sequence array
get '/twoboxes' do
	protected!
	erb:twoboxes
end

#Displays the page which shows the ammount of points inside the player's box which the player would have won if they hadn't taken the deal
get '/oneboxleftdeal' do
	protected!
	erb:oneboxleftdeal
end

#Displays the page which shows the ammount of points won when the finaldeal was taken and creates a log entry in the log.txt file
get '/takefinaldeal' do
	protected!
	$webgame.webfinaldealmessage
	$webgame.retrievedealvalue
	$webgame.updateLogFile("Deal")
	$webgame.updateScoreFile("finaldealtaken")
	erb:takefinaldeal #could add highscore log here
end

#Displays the page which shows the value that the player has won 
#when they decided to keep their own box during the final stage of the game when only two boxes were left
get '/openchosenbox' do
	protected!
	$webgame.webdisplaychosenboxvalue
	$webgame.updateLogFile("Openbox")
	$webgame.updateScoreFile("Openbox")
	erb:openchosenbox
end

#Retrieves lines from score.txt file and sorts them in a descending order (highest to lowest). 
#The first 5 scores then get assigned to a new variable to be displayed on the web page
get '/highscores' do
	scores = []
	scores = File.readlines('score.txt') #https://alvinalexander.com/blog/post/ruby/how-process-line-text-file-ruby
	scores.each do |line|
		scores = scores.map {|x| x.chomp }
	end
	scores.sort_by! {|s| s[/\d+/].to_i} #https://www.ruby-forum.com/topic/3940438
	scores.reverse!
	$highscores = scores.first(5)
	$scores = scores
	erb:highscores
end

#Displays the login page with the forms needed to login
get '/login' do
    erb:login
end

#Sends the details from the forms on the login.erb and compares them with the database tables which results in redirection to the approapriate page
post '/login' do
    $credentials = [params[:username],params[:password]]
    @Users = User.where(:username => $credentials[0]).to_a.first
    if @Users
        if @Users.try(:authenticate, $credentials[1])
        	$webgame.updateLogFile("Login")
            redirect '/'
        else
            $credentials = ['','']
            redirect '/wrongaccount'
        end
    else
        $credentials = ['','']
        redirect '/wrongaccount'
    end
end


#Displys the wrongaccount page when incorrect login details have been entered 
get '/wrongaccount' do
    erb:wrongaccount 
end

#Displays the createaccount page which has the requried forms for the creation of another entry in the database 
get '/createaccount' do
    erb :createaccount 
end

#Logs out the user and creates an entry in the log.txt file. Redirects to the home page
get '/logout' do
	$webgame.webresetgame
	$webgame.updateLogFile("Logout")
    $credentials = [' ',' ']
    redirect '/'
end

#Displays the admincontrols page and states a variable needed to display the lsit of registered users in a order determined by their id
get '/admincontrols' do
	adminprotected!
    @list2 = User.all.sort_by { |u| [u.id] }
    erb :admincontrols
end

#Initiates the methods needed to clear the database from every user that is not the admin and clears the log.txt and the score.txt file.
# Redirects back to the admincontrols page
get '/reset' do 
		adminprotected!
		n = User.where(admin: false)
		n.destroy_all
		File.truncate("log.txt", 0)
		File.truncate("score.txt", 0)
		redirect '/admincontrols'
end

#initiates the removal of a certain user in the database with certain conditions and protections against deleting the Admin user
get '/user/delete/:uzer' do
	adminprotected!
    n = User.where(:username => params[:uzer]).to_a.first
    if n.username == "Admin"
        erb :denied
    else
        n.destroy
        @list2 = User.all.sort_by { |u| [u.id] }
        erb :admincontrols
    end
end

#Used to display the user page if there is a user logged in, otherwise redirects to the /noaccount page
get '/user/:uzer' do
    @Userz = User.where(:username => params[:uzer]).first
    if @Userz != nil
        erb :profile
    else
        redirect '/noaccount'
    end
end

#Changes the edit boolean value of the edit table in the database
put '/user/:uzer' do
    n = User.where(:username => params[:uzer]).to_a.first
    n.edit = params[:edit] ? 1 : 0
    n.save
    redirect '/'
end

#Sends the data from the forms in the createaccount to the database and sets the values in the different tables of the database
post '/createaccount' do
    n = User.new
    n.username = params[:username]
    n.password = params[:password]
    n_unique = User.where(:username => params[:username]).to_a.first
    	n.edit = false
    	n.admin = false
    if n.username == "Admin" and n.password == "Password"
        n.edit = true
        n.admin = true
    elsif n_unique
        redirect '/notunique'
    end
    n.save
    redirect '/'
    #if the username already exists, redirect to error message
end

#Displays the denied page when the user tries to enter a link without permissions
get '/denied' do
    erb:denied
end

#Displays the notunique page when the username entered is already in the database
get '/notunique' do
    erb:notunique
end

#Displays the /noacount page which is called when the userpage is being accessed whithout a user signed in
get '/noaccount' do
    erb:noaccount
end

#Dispays the /notfound page
get '/notfound' do
	erb:notfound
end

#Displays the about page which contains the information about the creators of the web page
get '/about' do
	erb:about
end


not_found do
        status 404
        redirect '/notfound'
end
	# Any code added to web-based game should be added above.
# End program
