#https://github.com/han-gyeol/Genetic-Algorithm-Snake/blob/master/heuristic.js


# class for individual snakes
class Snek
	attr_accessor :id
	@@id = 0
	
	def initialize(pos_x, pos_y)
		@pos = [pos_x, pos_y] # coordinates of the snek's body, from head to tail

		# weights
		@id = @@id + 1
		@weights= []
		random = Random.new
		@w_staying_alive = random.rand(5)
		@weights.push @w_staying_alive
		@w_eating_food = random.rand(5)
		@weights.push @w_eating_food
		
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

	def initialize(pos_x, pos_y, weights)

		@pos=[pos_x,pos_y]
		@weights = weights

	end

	def eat(x, y)
		@pos.push [x,y]
	end

	def move(key, snake_ate)
		case key # and move head
			when "\e[A" # up
				pos.unshift [pos.first[0]+1, pos.first[1]]
			when "\e[B" # down
				pos.unshift [pos.first[0]-1, pos.first[1]]
			when "\e[C" # right
				pos.unshift [pos.first[0], pos.first[1]+1]
			when "\e[D" # left
				pos.unshift [pos.first[0], pos.first[1]-1]
		end
		pos.pop unless snake_ate # remove tail
	end

	def head
		return @pos.first
	end

	def tail
		return @pos.last
	end

	def pos
		return @pos
	end
	
	def to_s
		return "S p:#{@pos} w:#{@weights}"
	end
	
	def to_str
		return "S p:#{@pos} w:#{@weights}"
	end
	
	def getWeigths()
		return @weights
	end
	
	def setWeights(a)
		@weights = a
	end
end
