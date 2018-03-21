# class for individual snakes
class Snek
	def initialize(pos_x, pos_y)
		@pos_x = pos_x # initial position of snek
		@pos_y = pos_y

		# weights
		random = Random.new
		@w_staying_alive = random.rand(5)
		@w_eating_food = random.rand(5)
		# 7 heuristiques par snek :
		# - clear straight ahead
		# - clear to the left
		# - clear to the right
		# - food straight ahead
		# - food to the left
		# - food the right
		# - distance to food
		# En fonction des poids assignés à ces heuristiques pour ce snek, choisir la direction : left, right, ahead
		# on définit le best move par

		# on teste chaque mouvement possible, on en calcule la fitness, on choisit le best move en fonction de la fitness la plus élevée
		# pour chaque poids, on a une valeur à chaque tic
		# à chaque tic, on multiplie les valeurs aux poids et on somme le tout
		# on récupère ainsi la fitness
	end
end

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
