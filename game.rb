include './snake.rb'

# class for the game's logic and display
# take as constructor a boolean to activate or not the display of the game
class Game
	def initialize(display)
		@display = display
		@size_x = 50 # initial size of game grid
		@size_y = 50

		@game_over = false
		@moves = 0
		@score = 0
		@food = [10,10] # initial position of food
		@snek = Snek.new(25,25) # initial position of snek

		@board = Hash.new ' ' # store the game's board in a hashmap
		init_borders
		init_snek

		play
	end

	def init_borders
		@size_y.times do |y|
			@size_x.times do |x|
				if (x==0 || x==@box_length-1 ||  y == 0 || y==@box_width-1)
            	@drawing[[x,y]] = '-'
end
			end
		end
	end

	# play the game
	def play
		# check if game is over each frame
		while(!game_over?)
			frame
		end
	end

	# for each frame, run game logic
	def frame
		if(@display)
			draw! # update game display on console
		end
		# otherwise, just display current score

	end

	def draw!
		str = StringIO.new
		@size_y.times do |y|
			@size_x.times do |x|
				str.printf("%s", @drawing[[x,y]])
				str.printf("\n") if x == @box_length - 1
			end
		end
		str.rewind
		puts str.read
		str.rewind
		str
	end

	def game_over?
		if(@snek.pos_x <= 0 || @snek.pos_x >= 50
		|| @snek.pos_y <= 0 || @snek.pos_y >= 50)
			return true
		return false
	end
end
