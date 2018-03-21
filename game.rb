include './snake.rb'

# class for the game's logic and display
# take as constructor a boolean to activate or not the display of the game
class Game
	def initialize(display)
		@display = display
		@size_x = 50 # initial size of game grid
		@size_y = 50
		@game_over = false
		@score = 0
	end

	def play
		while(!game_over)
			frame
		end
	end

	# for each frame, run game logic
	def frame
		if(display)

		end
	end
end
