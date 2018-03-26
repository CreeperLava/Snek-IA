include './game.rb'
include './snek.rb'


########
#rajouter dans le jeu un truc pour accéder à la position de la food




class Heuristic

	def initialize
		@nb_iterations = 1000
		@heuristic = []

		@moves=["e\[A","e\[B","e\[C","e\[D"]   # up, down, right, left
		@food= game.food_pos
		random = Random.new
	end
	

	#Fitnesse pour chacun des moves du snek
	def calcFitness	

		
		heuristic[0]= @snek.weights[0]*@game_sim.distance_from_food
		heuristic[1]=@snek.weights[1]*@game_sim.score 
			
		for i in @heuristic.length
			@fitness+=heuristic[i]
			end
		end	

		return @fitness
	end

	def rand_population(n)
		pop=[]
		n.times{
			weight=[]
			heuristic.length.times weight.push random.rand(5)	
			pop.push Snek.new(((@game.@size_x)/2),((@game.@size_y)/2), weight)
			
		}
		return pop
	end

	def genetic_algorithm
	
		population= rand_population(50)
		@nb_iterations.times {
		#meilleur individu
		sickestest_snek = best(population)
		#nouvelle population
		}

		
	end

	def one_move
		game_sim=@game_snek

		best_fit=["",0]

		#faire jouer le snek
		@moves.each do |m| 
			@game_sim.next_frame(m)	
			@fitness=calcFitness	
			if @fitness > @best_fit[1]
				best_fit[0]=m
				best_fit[1]=@fitness
			end
			@game_sim=game_snek
		end	
		return best_fit[0]
	end	

	def best(pop)
		@game = Game.new(true, true, snek)
		@score_pop = Hash.new
		
		pop.each do |snek| 
			@game_snek = @game
			
			# On joue jusqu'à la mort 
			@game_snek.next_frame one_move until @game_snek.game_over?				
			

			# le snek est mort, l'ajouter à la hash map
			@score_pop[snek] = game_snek.score
		end
		sickestest_snek = sickestest(@score_pop)
	end 
	
	def sickestest(pop)
		max=0
		pop.each do |key, value| 
			if value > max	do 				
				max = value 
				snek = key
			end 	
		end	
		return snek
	end
end


