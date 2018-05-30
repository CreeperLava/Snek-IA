require './game.rb'
require './snek.rb'
require 'scanf'
require 'rubystats'

class Heuristic
	def initialize(debug, display)
		@debug = debug
		@display = display
		@nb_iterations = 100
		@taille_pop = 50
		@percent_best_snek = 0.25
		@percent_enfants = 0.25

		puts "[SNEK][RUN][initialize] Type y if you want custom values for the snek gaem"
		custom = ' ' # scanf("%c").first
		if custom == 'y'
			puts "[SNEK][RUN][initialize] Type the size of the snek population"
			@taille_pop = scanf("%d").first
			puts "[SNEK][RUN][initialize] Type how many times the algorithm must iterate"
			@nb_iterations = scanf("%d").first
			puts "[SNEK][RUN][initialize] Type the percentage of best sneks that must be used for the next generation"
			@percent_best_snek = scanf("%lf").first
		end

		puts "[SNEK][DEBUG][initialize] Creating most smart snek with #{@nb_iterations} iterations of smart algorime" if @debug
		@nb_heuristic = 6
		@heuristic = Array.new(@nb_heuristic)

		@moves=["\e[A","\e[B","\e[C","\e[D"]   # up, down, right, left
		@game = Game.new(true, true, Snek.new(25, 25, []))
		@start_x = @game.size_x/2
		@start_y = @game.size_y/2
		@food = @game.food
		puts "[SNEK][DEBUG][initialize] Initial position of food : #{@food}" if @debug
		@random = Random.new

		genetic_algorithm
	end


	# Fitness pour chacun des moves du snek
	def calcFitness(game_sim)
		@heuristic[0] = game_sim.snek.weights[0]*game_sim.distance_from_food
		@heuristic[1] = game_sim.snek.weights[1]*game_sim.squareness
		@heuristic[2] = game_sim.snek.weights[2]*game_sim.compactness
		@heuristic[3] = game_sim.snek.weights[3]*game_sim.score
		@heuristic[4] = game_sim.snek.weights[4]*game_sim.connectivity
		@heuristic[5] = game_sim.snek.weights[5]*game_sim.dead_end
		return @heuristic.sum # sum of heuristics = fitness
	end

	# returns random population of n sneks with default start coordinates and random array of weights
	def rand_population(n)
		return Array.new(n) { Snek.new(@start_x,@start_y, Array.new(@nb_heuristic) { @random.rand(-5.0..5.0) }) }
	end

	def gauss(weights, nb_children)
		# moyenne
		mean = weights.sum / weights.length

		# variance
		variance = weights.map {|w| w**2 }.sum # somme des weights au carré
		variance = (variance/weights.length) - (mean**2)
		# écart-type
		sd = Math.sqrt(variance)

		# génération de la loi normale
		gen = Rubystats::NormalDistribution.new(mean, sd)

		# return nb samples of gaussian law
		return gen.rng(nb_children)
	end


	#crée tous les enfants et remplissasse la population
	def children(pop)
		new_sneks = []
		#On remplit avec des nouveaux sneks random

		#On remplit la population avec les enfants des meilleurs, chaque meilleur va se reproduire avec deux autres meilleurs, un genre de polygamisme quoi
		nb_old_sneks = (@percent_best_snek*@taille_pop).round
		nb_children = (@percent_enfants*@taille_pop).round
		nb_random = @taille_pop - nb_old_sneks - nb_children

		# on crée une loi normale à partir du tableau du i-ème poids des sneks de pop
		# chaque ligne correspond à un nb_children poids générés à partir de cette loi normale
		new_gen_weights = []
		0.upto(@nb_heuristic-1) do |i|
			new_gen_weights[i] = gauss((pop.map{ |w| w.weights[i]}).flatten, nb_children)
		end

		# each line corresponds to the weights of one snek
		new_gen_weights = new_gen_weights.transpose
		puts "[SNEK][DEBUG][children] New weights for new sneks :" if @debug
		p new_gen_weights if @debug

		# children of best sneks through gaussian law
		new_gen_weights.each do |snek_weights|
			new_sneks.push Snek.new(@start_x,@start_y,snek_weights)
		end

		# keep best sneks from one gen to the next
		pop.each do |old_snek|
			new_sneks.push Snek.new(@start_x,@start_y,old_snek.weights)
		end
		puts "[SNEK][DEBUG][children] Gaussian sneks + old sneks :" if @debug
		puts new_sneks if @debug

		# add random sneks to complete population
		new_sneks += rand_population(nb_random)

		return new_sneks
	end

	def genetic_algorithm
		# on génère initialement une population aléatoire
		population = rand_population(@taille_pop)
		@nb_iterations.times do |i|
			# Renvoie les meilleurs individus
			sneks_to_breed = best(population)
			@best_snek = max(sneks_to_breed) if (i+1) == @nb_iterations

			# On génére une nouvelle population à partir des meilleurs
			puts "[SNEK][DEBUG][genetic_algorithm] Iteration #{i}" if @debug
			puts "[SNEK][DEBUG][genetic_algorithm] Best sneks :" if @debug
			puts sneks_to_breed if @debug
			population = children(sneks_to_breed)

			puts "[SNEK][DEBUG][genetic_algorithm] New population for next iteration" if @debug
			puts population if @debug
			puts "[SNEK][DEBUG][genetic_algorithm] Score de la population :" if @debug
			p @score_pop if @debug
		end
		puts "Sickestest snek after #{@nb_iterations} iterations : #{@best_snek}, with a score of #{@score_pop[@best_snek.id]}"
	end

	def one_move
		best_fit=["",nil]
		moves = @moves & @game_snek.possible_moves # remove moves that result in game over
		return @moves[0] if moves.length == 0 # if no move possible, return any move and kill yourself

		#faire jouer le snek
		moves.each do |m|
			game_sim = Marshal.load(Marshal.dump(@game_snek))
			game_sim.display = false
			game_sim.next_frame(m)
			game_sim.food = @game_snek.food # don't touch this, used so that we don't fuck up the distance_from_food

			@fitness = calcFitness(game_sim)

			best_fit = [m, @fitness] if (best_fit[1].nil? || @fitness >= best_fit[1])
		end


		if @debug
			move = ""
			case best_fit[0]
			when "\e[A" # up
				move = "up"
			when "\e[B" # down
				move = "down"
			when "\e[C" # right
				move = "right"
			when "\e[D" # left
				move = "left"
			end
			puts "[SNEK][DEBUG][one_move] Fit = #{@fitness}, snek moving #{move}" if @debug
		end

		p @game_snek.snek.pos if @debug
		return best_fit[0]
	end

	# On va faire jouer tous les sneks et voir qui sont les meilleurs avec sickestest
	def best(pop)
		@score_pop = Hash.new
		pop.each do |snek|
			@game_snek = Game.new(@display, true, snek)
			puts "[SNEK][DEBUG][best] On joue avec : #{snek}" if @debug
			# On joue jusqu'à la mort
			@game_snek.next_frame one_move until @game_snek.game_over?

			puts "[SNEK][DEBUG][best] Score du snek #{snek.id} : #{@game_snek.score}" if @debug
			# le snek est mort, l'ajouter à la hash map
			@score_pop[snek.id] = @game_snek.score
		end
		sickestest_sneks = sickestest pop
		return sickestest_sneks
	end

	# Rend les meilleurs sneks parmis une population de snek et score, avec pourcent le pourcentage des meilleurs
	def sickestest pop
		#nb de meilleurs snek à garder
		@nb_breeding_pool = (@percent_best_snek*pop.length.to_f).round

		sneks_to_breed = []
		#on prend le meilleur et on l'enlève de la pop, pour recommencer jusqu'à temps qu'on ai les 10% de meilleurs sneks dans 'sneks_to_breed'
		@nb_breeding_pool.times do
			best = max(pop)
			puts best if @debug
			pop.delete best
			sneks_to_breed.push best
		end
		return sneks_to_breed
	end

	def max pop
		max, max_snek = -1, nil
		pop.each do |snek|
			max, max_snek = @score_pop[snek.id], snek if @score_pop[snek.id] >= max
		end
		return max_snek
	end
end

Heuristic.new(false, true) # debug, display
