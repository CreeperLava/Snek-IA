require './game.rb'
require './snek.rb'
require 'scanf'

class Heuristic
	@@mutation_rate = 0.9
	def initialize
		@nb_iterations = 1000
		@taille_pop = 50
		@percent_best_snek = 0.1
		
		puts "[SNEK][RUN][initialize] Type y if you want custom values for the snek gaem"
		custom = scanf("%c").first
		if custom == 'y'
			puts "[SNEK][RUN][initialize] Type the size of the snek population"
			@taille_pop = scanf("%d").first
			puts "[SNEK][RUN][initialize] Type how many times the algorithm must iterate"
			@nb_iterations = scanf("%d").first
			puts "[SNEK][RUN][initialize] Type the percentage of best sneks that must be used for the next generation"
			@percent_best_snek = scanf("%d").first
		end
		
		puts "[SNEK][DEBUG][initialize] Creating most smart snek with #{@nb_iterations} iterations of smart algorime"
		@nb_heuristic = 2
		@heuristic = Array.new(@nb_heuristic)

		@moves=["\e[A","\e[B","\e[C","\e[D"]   # up, down, right, left
		
		@game = Game.new(true, true, Snek.new(25, 25, []))
		@food = @game.food
		puts "[SNEK][DEBUG][initialize] Initial position of food : #{@food}"
		@random = Random.new
		
		genetic_algorithm
	end
	

	#Fitnesse pour chacun des moves du snek
	def calcFitness(game_sim)
		fitness = 0
		@heuristic[0] = game_sim.snek.weights[0]*game_sim.distance_from_food
		
		@heuristic[1] = game_sim.snek.weights[1]*game_sim.score 
		puts "[SNEK][DEBUG][calcFitness] Heuristic 2 : #{@heuristic[1]}"
		@heuristic.each do |h|
			fitness += h
		end
		
		puts "[SNEK][DEBUG][calcFitness] Heuristics : #{fitness}"
		return fitness
	end

	def rand_population(n)
		pop = []
	
		n.times do
			weight = []
			
			@nb_heuristic.times do 
				p= @random.rand(5)
				weight.push p
			end
			pop.push Snek.new(((@game.size_x)/2),((@game.size_y)/2), weight)
			
			
		end
		
		
		puts "[SNEK][DEBUG][rand_population] First 10 individuals of population :"
		puts pop[0..10]
		return pop
	end

	# crée un enfant, (un tableau de poids donc) à partir de deux parents
	def child(s1,s2)
		poids = []
		#pour chaque poids dans chaque tableau de pois des deux sneks
		[s1.weights,s2.weights].each_with_index  do |w1,w2, i|
			poids[i] = [w1,w2].sample
			
			#Mutation à rajouter
		end
		return poids
	end

	#crée tous les enfants et remplissasse la population
	def children(pop)
		children = []
		#On rempli avec des nouveaux sneks random
		children = rand_population(@taille_pop-pop.length)
		#On rempli la population avec les enfants des meilleurs, chaque meilleur va se reproduire avec deux autres meilleurs, un genre de polygamisme quoi
		(@taille_pop-1).upto(pop.length) do |i|
			if i < pop.length
				children[i] = Snek.new(((@game.size_x)/2),((@game.size_y)/2),child(pop[i],pop[i+1]))
			else
				children[i] = Snek.new(((@game.size_x)/2),((@game.size_y)/2),child(pop[i],pop[0]))
			end
		end
		mutate(children)
		return children
	end
	
	def genetic_algorithm
		population = rand_population(@taille_pop)
		puts " population : #{population}"
		@nb_iterations.times do |i|
			#meilleurs individus
			sneks_to_breed = best(population)
			#nouvelle population
			@best_snek = sickestest(sneks_to_breed, (1/@taille_pop))
			children = children(sneks_to_breed)
			puts "[SNEK][DEBUG][genetic_algorithm] Iteration #{i}"
			puts "[SNEK][DEBUG][genetic_algorithm] Best sneks : #{sneks_to_breed}"
			puts "[SNEK][DEBUG][genetic_algorithm] Children of best sneks : #{children}"
		end
		puts "Sickestest snek after #{i} iterations : #{@best_snek}"
	end

	def one_move
		
		best_fit=["",0]

		#faire jouer le snek
		@moves.each do |m| 
			puts "snek avant : #{@game_snek.snek}"
			game_sim=Game.new(false,true,@game_snek.snek)
			game_sim.food=@game_snek.food
			puts "snek apres : #{game_sim.snek}"
			game_sim.next_frame(m)	
			@fitness=calcFitness(game_sim)	
			puts " fit = #{@fitness}"
			if @fitness > best_fit[1]
				best_fit[0]=m
				best_fit[1]=@fitness
			end
		end	
		return best_fit[0]
	end	

	#On va faire jouer tous les sneks et voir qui sont les meilleurs avec sickestest
	def best(pop)
		puts " on est là"
		@score_pop = Hash.new
		
		pop.each do |snek| 
			@game_snek = Game.new(true, true, snek)
			
			# On joue jusqu'à la mort 
			@game_snek.next_frame one_move until @game_snek.game_over?				
			
			puts" score pour le snek #{snek.id} : #{@game_snek.score}"
			# le snek est mort, l'ajouter à la hash map
			@score_pop[snek] = @game_snek.score
		end
		sickestest_sneks = sickestest(@score_pop, 0.1)
		return sickestest_sneks
	end 
	
	#Rend les meilleurs sneks parmis une population de snek et score, avec pourvent le pourcentage des meilleurs
	def sickestest(pop, pourcent)	
		#nb de meilleurs snek à garder 
		@nb_breeding_pool= (pourcent*pop.length).round

		sneks_to_breed = [@nb_breeding_pool]
		#on prend le meilleur et on l'enlève de la pop, pour recommencer jusqu'à temps qu'on ai les 10% de meilleurs sneks dans 'sneks_to_breed'
		for i in 0..@nb_breeding_pool
			best = max(pop)
			pop.delete(best)
		end
		return sneks_to_breed
	end

	def max(pop)
		max=0
		pop.each do |snek, score| 
			puts"#{score}"
			max =  score if  score > max
		end
		return max
	end
		
	def mutate(sneks)
		sneks.each do |snek|
			next if random.rand >= mutation_rate
			newWeights = snek.getWeights()
			for i in 0..random.rand(newWeights.length)
				newWeights[random.rand(newWeights.length)] = random.rand(5)
			end
			snek.setWeights(newWeights)
		end
	end
end

Heuristic.new
