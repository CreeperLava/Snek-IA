# SNAKES GAME
# Use ARROW KEYS to play, SPACE BAR for pausing/resuming and Esc Key for exiting
class game:
	import curses
	from curses import KEY_RIGHT, KEY_LEFT, KEY_UP, KEY_DOWN
	from random import randint

	size_x = 60
	size_y = 20

	curses.initscr()
	win = curses.newwin(size_y, size_x, 0, 0)
	win.keypad(1)
	curses.noecho()
	curses.curs_set(0)
	win.border(0)
	win.nodelay(1)

	key = KEY_RIGHT													# Initializing values
	score = 0

	snake = [[4,10], [4,9], [4,8]]									 # Initial snake co-ordinates
	food = [10,20]													 # First food co-ordinates

	win.addch(food[0], food[1], '*')								   # Prints the food

	while key != 27:												   # While Esc key is not pressed
		win.border(0)
		win.addstr(0, 2, 'Score : ' + str(score) + ' ')				# Printing 'Score' and
		win.addstr(0, 27, ' SNAKE ')								   # 'SNAKE' strings
		win.timeout(150 - (len(snake)/5 + len(snake)/10)%120)		  # Increases the speed of Snake as its length increases

		prevKey = key												  # Previous key pressed
		event = win.getch()
		key = key if event == -1 else event


		if key == ord(' '):											# If SPACE BAR is pressed, wait for another
			key = -1														# one (Pause/Resume)
			while key != ord(' '):
				key = win.getch()
			key = prevKey
			continue

		if key not in [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN, 27]:	 # If an invalid key is pressed
			key = prevKey

		# Calculates the new coordinates of the head of the snake. NOTE: len(snake) increases.
		# This is taken care of later at [1].
		snake.insert(0, [snake[0][0] + (key == KEY_DOWN and 1) + (key == KEY_UP and -1), snake[0][1] + (key == KEY_LEFT and -1) + (key == KEY_RIGHT and 1)])

		# Exit if snake crosses the boundaries (Uncomment to enable)
		if snake[0][0] == 0 or snake[0][0] == size_y - 1 or snake[0][1] == 0 or snake[0][1] == size_x - 1: break

		# If snake runs over itself
		if snake[0] in snake[1:]: break

		if snake[0] == food: 
			self.eat_food()
		#else: last = snake.pop()										
			#win.addch(last[0], last[1], ' ')
		def eat_food(self):
			self.food = []
			self.score += 1
			self.moar_food
			win.addch(food[0], food[1], '*')	
			win.addch(snake[0][0], snake[0][1], '#')


		def moar_food(self):
			while self.food == []:
				food = [randint(1, size_y - 2), randint(1, size_x - 2)] # à changer, il faudrait faire un random int sur là où est le snek pour ne pas avoir à refaire les calculs à l'infini
				if food in snake: food = []

	curses.endwin()
	print("\nScore - " + str(score))


	def play(self):
		    while 1:
		        move = self.snek.tick()
		        if move == 'food':
		            self.eat_food()
		        if move == 'lose': break
	time.sleep(0.3)

class snekbot:

	#position du snek
	pos = game.snake

	
	def __init__(self,game):
		self.game=game
		self.pos = [(1,1),(1,2)]#.append((0,0))
		self.weight_food = random.uniform(0,5)
		#self.weight_selfd = random.uniform(-5,0)

	def play(self):
		sneks = sneks([])		
		for snek in sneks:


	def tick(self):
		m = self.sickestest_move()
		if m == None: return 'lose'
		elif m == self.game.food:
			self.bigger(m)S
			return 'food'
		else:
			self.move(m)
			return ''
			
			
	def move(self,to):
		self.pos.pop()
		self.pos.insert(0,to)

	def bigger(self,to):
		self.pos.insert(0,to)

	def weight_move(self,move):
        w = self.weight_food* self.game.score(move)
        return w #+ (self.weight_selfd*self.distance_score(move))

	# Returns the score
	def fitness (score):
		return score
	"""
	Sneks
	"""
	# Population
	def sneks(sneks,self):
		if sneks == []:
			// créer population
		else:
			// prendre les premiers sneks, et générer aléatoirement les autres
		return

	#calcule la distance entre deux points du jeu 
	def distance(a,b):
		return ((a[0]-b[0])**2)+((a[1]-b[1])**2)

	#retourne la distance entre la tête du snek et la bouffe
	def distance_food(self):
		return distance(game.food,self.pos[0])
		


	# Random
	def random_snek(self):
		return
	# Mutation
	def weird_snek(self):
		return
	# Selection
	def most_stronk_snek(sneks_score, self):
		return
	# All availables movements
	def sick_moves(self):
		moves = []
		moves.append([pos[0][0] + 1, pos[0][1]])
		moves.append([pos[0][0] - 1, pos[0][1]])
		moves.append([pos[0][0], pos[0][1] + 1])
		moves.append([pos[0][0], pos[0][1] - 1])

		for move in moves:
			if move == snake[1] and (move[0] <= 0) and (move[0] > self.game.grid_size[0]) and 
(move[1] <= 0) and (move[1] > self.game.grid_size[1])):
				moves.remove(move)
				break
		return moves

	# Best move
	def sickestest_move(self):
		tab2 =[[]]
		tab = self.sick_moves()
		#if taille = 0, on perd
		if len(tab) == 0: return None
 
		for move in tab:
			tab2.append(poid(move), move)
		tab2.sort
		return tab2[0][1]

#https://github.com/stephennancekivell/growing-snakes/blob/master/snake.py
