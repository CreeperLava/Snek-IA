include './game.rb'
include './snek.rb'


########
#rajouter dans le jeu un truc pour accéder à la position de la food




class Heuristic

	def initialize(snek,weights,game)	
		@snek=snek
		@game_sim=game
		@head = snek.head	
		@heuristic = [][]

		@food= game.food_pos                          #<---------------
		#Tableau des différents moves possible du snek
		#@moves = [[(head[0]+1),head[1]],
		#[head[0],(head[1]+1)],
		#[head[0],(head[1]-1)],
		#[(head[0]-1),head[1]]
		#]
		@best_fit=["",0]

		@moves=["UP","DOWN","LEFT","RIGHT"]
		@moves.each  { |m| 
			@game_sim.next_frame(m)	
			@fitness=calcFitness	
			if @fitness > @best_fit[1]
				@best_fit[0]=m
				@best_fit[1]=@fitness
			end
			@game_sim=game	
			}
		

		

	end
	

	#Fitnesse pour chacun des moves du snek
	def calcFitness	

		
		heuristic[0]=weights[1]*@game_sim.distance_from_food
		heuristic[1]=weights[2]*score #les murs plus lui-même
			
		for i in @heuristic.length
			@fitness+=heuristic[i]
			end
		end	

		return @fitness
	end


	def distance_from_food
		
		@xDist = abs(food.x - this.snek.x) / game.scale;
		@yDist = abs(food.y - this.snek.y) / game.scale;
		return (xDist + yDist);
	end

	def score
			
	
	end
