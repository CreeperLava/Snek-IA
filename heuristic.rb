include './game.rb'
include './snek.rb'


class Heuristic

	def initialize(snek,weights)	
		snek=snek
		fitness=0		
	end
	


	def calcFitness		
		heuristic[1]=weights[1]*distance_from_food()
		heuristic[2]=weights[2]*dead_end() #les murs plus lui-même

		for i in heuristic.length()
			somme+=heuristic[i]
		end
		return somme
	end
