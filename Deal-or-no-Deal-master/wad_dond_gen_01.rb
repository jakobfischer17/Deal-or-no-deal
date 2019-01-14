# Ruby code file - All your code should be located between the comments provided.

# Main class module
module DOND_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	GOES = 22

	class Game
		attr_reader :sequence, :selectedboxes, :openedboxes, :chosenbox, :selectedbox, :turn, :input, :output, :winner, :played, :wins, :losses, :guess, :values, :amounts, :message
		attr_writer :sequence, :selectedboxes, :openedboxes, :chosenbox, :selectedbox, :turn, :input, :output, :winner, :played, :wins, :losses, :guess, :values, :amounts, :message

		def initialize(input, output)
			@input = input
			@output = output
		end
		
		def getinput
			@input.gets.chomp.upcase
		end
		
		def storeguess(guess)
			if guess != ""
				@selectedboxes = @selectedboxes.to_a.push "#{guess}"
			end
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added below.
	

	#############################################################################################
	#Original Methods That Are Part of the Spec File Start
	####################################################################################
	#puts out strings and gets called at start of game
	def start 
		@output.puts "Welcome to Deal or No Deal!"
		@output.puts "Designed by: #{created_by}"
		@output.puts "StudentID: #{student_id}"
		@output.puts "Starting game..."
	end
	
	def created_by
		"Chidozie Nnachor, Jakob Fischer and Maksim Lilchev"
	end
	
	def student_id
		"51773318, 51773261, 51773600"
	end
	
	def displaymenu
		@output.puts "Menu: (1) Play | (2) New | (3) Analysis | (9) Exit"
	end
	
	#creates/resets all object variables needed in the game to 0 again
	def resetgame
		@output.puts "New game..."
		@sequence = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		@selectedboxes = []
		@openedboxes = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		@chosenbox = 0
		@selectedbox = 0
		@turn = 0
		@game = 0
		@winner = 0
		@played = 0
		@wins = 0
		@losses = 0
		@guess = ""
		@values = [0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00]
		@amounts = @values
		@offervalue = 0
		@openedbox = 0
		@loop = 0
	end
	
	#shuffles the values of the @values string and puts them inside of the @sequence string
	def assignvaluestoboxes#
		@sequence = @values.shuffle
	end
	
	#iterates through the method 22 times, checking if the value of @openedboxes is 0 (box closed) or 1(box opened)
	#and prints the result to the console like this \openedbox/ or [closedbox]
	def showboxes 
		for i in (0..21) do
			s = "_"
			g = "_"
			b = i + 1
			sleep 0.04
			if @openedboxes[i] == 0
				s = "Closed"
				g = "[#{b}]"
				if b == @chosenbox
					g = "*#{b}*"
				end
			else
				s = "Opened"
				g = "\\#{b}/"
			end
			@output.print "#{g} "
		end
	end

	#displays values  of the array @amounts in columns, to inform th player about the remaining box values in the game
	def showamounts 
		col1 = 0
		col2 = 11
		for i in (0..10)
			sleep 0.02
			c1 = @amounts[col1 + i]
			c2 = @amounts[col2 + i]
			@output.puts "#{c1}   #{c2}"
		end
	end
	
	#passes the test
	def removeamount(value)
		index = @amounts.find_index(value)
		@amounts[index] = "    "
	end
	
	#sets @chosenbox equal to the input received
	def setchosenbox(b)
		@chosenbox = b
	end
	
	#method getchosenbox has the value of @chosenbox
	def getchosenbox
		@chosenbox
	end
	
	#sets @openedbox equal to the input received
	def setopenedbox(b)
		@openedbox = b
	end
	
	#puts string with number of the players box he chose in the beginning
	def displaychosenbox
		@output.puts "Chosen box: [#{getchosenbox}]"
	end
	
	def displaychosenboxvalue
		@output.puts "Chosen box: [#{getchosenbox}] contains: #{@sequence[@chosenbox-1]}"
	end
	
	#puts string with value of t he box number the player opened
	def displayopenedboxvalue
		@output.puts "Opened box: [#{getopenedbox}] contains: #{@sequence[@openedbox.to_i-1]}"
	end
	
	#puts string that asks player for input
	def displaychosenboxprompt
		@output.puts "Enter the number of the box you wish to keep."
	end
	
	#error the player gets when he/she tries to enter a value that is not between 1 and 22
	def displaychosenboxerror#
		@output.puts "Error: Box number must be 1 to 22."
	end
	
	#error the player gets when he/she tries to open the box he chose in the beginning
	def openedboxnotuniqueerror
		@output.puts "Error: You can't open the box you chose in the beginning!."
	end
 
	#error the player gets when he/she tries to open a box that is already open
	def openedboxeserror
		@output.puts "Error: You can't open a box you have already opened!."
	end
	
	#puts string that informs player that they will not get another banker offer, as there are only two boxes left.
	def finaltwoboxes
		@output.puts "There are two boxes left. As you have not taken any banker offer, \n it is assumed that you want to open your own box now."
	end
	
	#puts string that informs player that he/she has the chance to see what is inside their chosen box now
	def finaltwoboxesdealtaken
		@output.puts "There are two boxes left. You have taken the bankers offer, \nso to see what you could have gotten it is assumed that you want to open your own box now."
	end
	
	#puts string thath informs the player with what they did win vs. what they could have gotten when they opened their own box.
	def finaldealmessage
		@output.puts "You won: #{@offervalue} when you took the deal. Your box contained: #{@sequence[@chosenbox.to_i-1]}"
	end
	
	# iterates 22 times, checking if the value of @openedboxes is 0 (box closed) or 1(box opened)
	#and prints the result to the console in the form of: [boxnumber] Status: Closed/Opened
	def displayanalysis
		@output.puts "Game analysis..."
		for i in (0..21) do
			s = "_"
			g = "_"
			b = i + 1
			if @openedboxes[i] == 0
				s = "Closed"
				g = "[#{b}]"
			else
				s = "Opened"
				g = "[#{b}]"
			end
		@output.puts "#{g} Status: #{s}"
		end
	end
	
	#checks if a box number is between 1 and 22 and sets the variable vlaid to 0 for valid and 1 for invalid
	def boxvalid(i)
		guess = i.to_i
		valid = guess
		if guess > 0 && guess <= 22 #&& guess != @chosenbox
			valid = 0
		else
			valid = 1
		end
	end
	
	#shows log of already openedboxes
	def showselectedboxes
		@output.puts "Log: #{selectedboxes.inspect}"
	end
	
	#prompts user for input
	def displayselectboxprompt
		@output.puts "Enter the number of the box you wish to open. Enter returns to menu."
	end
	
	#initial version used to pass the rspec test
	def openbox(guess)
		boxnumber = guess.to_i
		s = "Placeholder"
		if boxnumber != nil
			s = "Opened"
			@output.puts "#{boxnumber} Status: #{s}"
		end
	end

	##This method is only used to pass the test
	def bankerphoneswithvalue(offer)
		@output.puts "Banker offers you for your chosen box: #{offer}"
	end
	
	#This method is only used to pass the test
	def bankercalcsvalue(value)
		value = value / 2
	end
	
	#counts number of boxes that are still closed by counting 0s in @openedboxes (not actually used in program)
	def numberofboxesclosed
		num = "Placeholder"
		num = @openedboxes.count(0).to_i
	end
	
	#increments turn by 1
	def incrementturn
		@turn += 1
	end

	#substratcs GOES (22 initially) with @turn to retrieve the turns left (practically not used)
	def getturnsleft
		turnsleft = "Placeholder"
		turnsleft = GOES - @turn
	end
	
	#puts string
	def finish
		@output.puts "... game finished."
	end
	

#################################################################################################
#Original Methods That Are Part of the Spec File End
################################################################################################

#################################################################################################
#Console Methods Added Start
#################################################################################################

	#puts new line character
	def newline
		@output.puts "\n"
	end
	
	#sets @loop to 20 to get back to the menu
	def loopbreaker
		@loop = 20
	end
	
	#increments @loop by 1
	def incrementloop
		@loop += 1
	end

	#counts number of boxes that are still closed by counting 0s in @openedboxes
	def unopenedboxesleft
		@openedboxes.count(0)
	end

	#calculates the n ofer based on the highest and lowest values together with the number of boxes left;
	def bankercalcsoffer
		bankcalcarray = Array.new
		bankcalcarray = @amounts
		bankcalcarray.delete("    ")
		value = (bankcalcarray.max + bankcalcarray.min / 2 ) / (bankcalcarray.count + rand(1..5))
		@offervalue = value.to_i.ceil(-2)
	end

	#shows when player inputs something other than Y or N
	def selectdealornodeal
		@output.puts "Error: please select Y or N."
	end

		#sets @openboxes array to 1 at the index of the opened box number and informas the player that the box has been opened
	def openboxes(guess) 
		boxnumber = guess.to_i
		s = "Placeholder"
		if boxnumber != nil
			s = "Opened"
			@output.puts "#{boxnumber} Status: #{s}"
			boxnumber = boxnumber - 1
			@openedboxes[boxnumber] = 1
		end
	end
	
	#puts banker offer that is contained in variable @offervalue	
	def bankerphoneswithoffer 
		@output.puts "Banker offers you for your chosen box: #{@offervalue}"
	end
	
	#promps player for input
	def dealornodeal
		@output.puts "Reply Y if you want to take the offer or N if you do not."
	end
	
	#puts confirmation to player that they have taken the deal and that the game will continue 
	def makedeal
		@output.puts "You took the deal! You won: #{@offervalue}"
		@output.puts "The game will continue so you can see what other offers you could have gotten."
	end

	def promptpick
		@output.print "\n\nPick your box!"
	end

	#removes the value of@sequence at index of the number the user entered -1 from @amounts
	def removeamounts(value) 
		value = value.to_i - 1
		value = @sequence[value]
		index = @amounts.find_index(value).to_i  
		@amounts[index] = "    "
	end
	
	#accesses @openedboxes value of inputted index 
	def checkbox(value)
		@openedboxes[value]
	end

	#method getopenbox has the value of @openedbox
	def getopenedbox
		@openedbox
	end

	#shows the value of the players box he chose in the beginning when the player takes a deal. To create tension, the output is delayed by the sleep function
	def displaychosenboxvaluedeal
		@output.puts "It is time! Your chosen box is being opened..."
		10.times do
			sleep 0.4 
			@output.print "."
		end
		@output.puts "Chosen box: [#{getchosenbox}] contains: #{@sequence[@chosenbox.to_i-1]} \n #{message}"
	end

	#shows the value of the players box he chose in the beginning. To create tension, the output is delayed by the sleep function
	#displays a different message depending on the amount the player won
	def displaychosenboxvalues
		@output.puts "It is time! Your chosen box is being opened..."
		10.times do
			sleep 0.4 
			@output.print "."
		end
		if @sequence[@chosenbox.to_i-1] < 10000
			message = "Oh no! Better luck next time.."
		elsif @sequence[@chosenbox.to_i-1] >=10000 && @sequence[@chosenbox.to_i-1] < 50000
			message = "Congratulations! You did well, but can you do better?"
		elsif @sequence[@chosenbox.to_i-1] >=50000 && @sequence[@chosenbox.to_i-1] < 250000
			message = "Wow! Congratulations, you did extremely well!"
		elsif @sequence[@chosenbox.to_i-1] == 250000
			message = "JACKPOT!!! You played the perfect game! Congratulations!"
		end
		@output.puts "Chosen box: [#{getchosenbox}] contains: #{@sequence[@chosenbox.to_i-1]} \n #{message}"
	end

#################################################################################################
#Console Methods Added End
#################################################################################################

################################################################################################
#Sinatra-Specific Methods Start
#############################################################################
#These are methods that are only used for the sinatra version of the game. Some of them are copies of the methods above without the .puts method 
#or similar minor alterations. 
    

    #used to call the message
	def webdisplaychosenboxvalue
		@displaychosenboxvalue = "Chosen box: [#{@chosenbox}] contains: #{@sequence[@chosenbox.to_i-1]}."
	end

	#used to call the message
	def webfinaldealmessage
		@finaldealmessage = "You won: #{@offervalue} when you took the deal. Your box contained: #{@sequence[@chosenbox.to_i-1]}"
	end

	#assigns a value to the @dealvalue variable used to display 
	def retrievedealvalue
		@dealvalue = @offervalue
	end
	
	#used to display the @dealvalue
	def displaydealvalue
		@dealvalue
	end

	#used to display the vaule of the @openedboxvalue
	def webdisplayopenedboxvalue
		@openedboxvalue = "Opened box: [#{input}] "
	end

	#used to access the @openedboxes in order to check if the index position is 1 or 0
	def webopenboxes(guess) 
		boxnumber = guess.to_i
		if boxnumber != nil
			boxnumber = boxnumber - 1
			@openedboxes[boxnumber] = 1
		end
	end

	#used to display the banker offer in .erb files
	def webbankerphoneswithoffer 
		@bankeroffer = "Banker offers you for your chosen box: #{@offervalue}"
	end

	#based on the console version with several new variables inserted 
	def webresetgame
		@sequence = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		@selectedboxes = []
		@openedboxes = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		@chosenbox = 0
		@selectedbox = 0
		@turn = 0
		@game = 0
		@winner = 0
		@played = 0
		@wins = 0
		@losses = 0
		@guess = ""
		@values = [0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00]
		@amounts = @values
		@offervalue = 0
		@openedbox = 0
		@loop = 0
		@bankeroffer = ""
		@openedboxvalue = ""
		@dealvalue = 1
		@finaldealmessage = ""
		@displaychosenboxvalue = ""
		@offervalue = ""
		@webgame = ""
		@input = 1
		@turn = 0
		$dealtakenornot = false
	end

	#used to show the status of the boxes
	def webshowboxes 
			for i in (0..21) do
				s = "_"
				g = "_"
				b = i + 1
				
				if @openedboxes[i] == 0
					s = "Closed"
					g = "[#{b}]"
					if b == @chosenbox
						g = "*#{b}*"
					end
				else
					s = "Opened"
					g = "\\#{b}/"
				end
			end
	end

	#used to display the status of the boxes in the "/displayanalysis"
	def webdisplayanalysis
		for i in (0..21) do
			s = "_"
			g = "_"
			b = i + 1
			if @openedboxes[i] == 0
				s = "Closed"
				g = "[#{b}]"
			else
				s = "Opened"
				g = "[#{b}]"
			end
		end
	end

	def webgetinput
		@input
	end

	#def webopenboxes(guess) 
	#	boxnumber = guess.to_i
	#	s = "Placeholder"
	#	if boxnumber != nil
	##		s = "Opened"
	#		boxnumber = boxnumber - 1
	#		@openedboxes[boxnumber] = 1
	#	end
	#end

	#used to update the log file with different descriptions for several actions
	def updateLogFile(operation)
	    file = File.open("log.txt", "a")
		if operation == "Login"
		        file.puts "#{$credentials[0]} logged in at #{Time.now}"
		elsif operation == "Logout"
		        file.puts "#{$credentials[0]} logged out at #{Time.now}"
		elsif operation == "Viewlog"
		        file.puts "#{$credentials[0]} viewed this file at #{Time.now}"
		elsif operation == "Deal"
		        file.puts "#{$credentials[0]} won by taking a deal: #{$webgame.displaydealvalue}"
		        $dealtakenornot = true
		elsif operation == "Openbox"
		        file.puts "#{$credentials[0]} won by opening his own box: #{$webgame.sequence[$webgame.chosenbox.to_i-1]}"
		end
	        file.close
	end

	#used to update the score file 
	def updateScoreFile(operation)
		file = File.open("score.txt", "a")
		if operation == "Deal"
		        file.puts "#{$credentials[0]} : #{$webgame.displaydealvalue}"
		elsif operation == "finaldealtaken"
		        file.puts "#{$credentials[0]} : #{$webgame.displaydealvalue}"
		elsif operation == "Openbox"
		        file.puts "#{$credentials[0]} : #{$webgame.sequence[$webgame.chosenbox.to_i-1]}"
		end
	        file.close
	end
	

###############################################################################
#Sinatra-Specific Methods End
########################################################################
			# Any code/methods aimed at passing the RSpect tests should be added above.



	end
end