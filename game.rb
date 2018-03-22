require './snek'
require 'io/console'

# class for the game's logic and display
# take as constructor a boolean to activate or not the display of the game

# y
# *----------------*
# |				         |
# |		 ~~~^	       |
# |				         |
# |				       x |
# *----------------* x
#

class Game
	def initialize(display, ai)
		@display = display # is display of the game activated or not
		@ai = ai # is snek controlled by an AI or a human
		@size_x = 50 # initial size of game grid
		@size_y = 50 # coordinates 0,y, 50,y and 0,x, x,50 are borders
		@scale = @size_x/@size_y  #scale of the window, used for now in heuristic

		@game_over = false
		@moves = 0
		@score = 0

		@snek = Snek.new(25, 25) # initial position of snek
		@rng = Random.new

		# create size_x*size_y matrix
		# init to ' ' except for borders (*,|,_), food(x) and snek head (^)
		# create array to store list of free tiles -> avoid looking up the whole matrix

		@board = [[]] # store the game's board in a matrix, stored line by line. board[2][14] -> line 2, column 14
		init_board
		init_free_tiles # store the empty tiles of the board
		init_snek
		new_food

		@just_ate = false
		@last_key_pressed = ''
		play
	end

	def init_board
		(0..@size_y).each do |y| @board[y] = [] end

		# top border (y=0)
		@board[0][0] = '*'
		(1..@size_x-1).each do |x|
			@board[0][x] = '_'
		end
		@board[0][@size_x] = '*'

		# inside (y=1..49) and vertical borders (x=0, x=50)
		(1..@size_y-1).each do |y|
			@board[y][0] = '|'
			(1..@size_x-1).each do |x|
				@board[y][x] = ' '
			end
			@board[y][@size_x] = '|'
		end

		# bottom border (y=50)
		@board[@size_y][0] = '*'
		(1..@size_x-1).each do |x|
			@board[@size_y][x] = '_'
		end
		@board[@size_y][@size_x] = '*'
	end

	def init_snek
		@snek.head do |x, y|
			@board[y][x] = '^'
		end
	end

	# store empty tiles where food can spawn
	def init_free_tiles
		@free_tiles = []
		i = 0
		(1..@size_y-1).each do |y|
			(1..@size_x-1).each do |x|
				@free_tiles[y*i+x] = [x, y]
			end
			i+=1
		end
		@free_tiles.delete(@snek.head)
	end

	def free_tile?(x, y)
		return @free_tiles.find_index([x, y]) != nil
	end

	# play the game
	def play
		# check if game is over each frame
		until game_over?
			next_frame
		end
	end

	def new_food
		a = @rng.rand(@free_tiles.length)
		p a
		p @free_tiles.length
		@food = [@free_tiles[a][0], @free_tiles[a][1]] # new position of food, within borders
	end

	# for each frame, run game logic
	def next_frame
		if @ai
			# await the AI's decision -> call a method from heuristic
		else
			read_char # get key pressed
			move_snek
			sleep(1) # 1 FPS 1080p
		end

		if @display
			draw! # update game display on console
		end
		# otherwise, just display current score
	end

	def read_char
		STDIN.echo = false
		STDIN.raw!

		key = STDIN.getc.chr
		if key == "\e"
			key << STDIN.read_nonblock(3) rescue nil
			key << STDIN.read_nonblock(2) rescue nil
		elsif key == "\e[A" || key == "\e[B" || key == "\e[C" || key == "\e[D"
			@last_key_pressed = key
		end
	ensure
		STDIN.echo = true
		STDIN.cooked!
	end

	# move snek : remove tail, move head
	# edit free tiles
	# edit matrix
	# edit snek pos
	def move_snek
		@snek.move(@last_key_pressed, @just_ate)

		if @just_ate # if snake ate, it grew, thus don't remove tail
			@board[@snek.tail[1]][@snek.tail[0]] = ' '
			@free_tiles.push(@snek.tail)

			@just_ate = false
		end

		@board[@snek.head[1]][@snek.head[0]] = '^'
		@free_tiles.delete(@snek.head)
		@board[@snek.pos[1][1]][@snek.pos[1][0]] = '~'
	end

	def draw!
		# check if it is possible to keep the StringIO from frame to frame and just edit what changed, then rewind and read
		str = StringIO.new

		@size_y.times do |y|
			p @board[y].to_s
			str.printf("%s\n", @board[y].to_s)
		end

		str.rewind
		puts str.read
		str.rewind
		str
	end

	def game_over?
		head_x = @snek.head[0]
		head_y = @snek.head[1]
    hit = @snek.pos.find_all { |e| e == [head_x, head_y] } # we hit ourselves if there is another tile of the snek with the coordinates of the head
		# if we hit a wall or ourselves, return true
		if head_x <= 0 || head_x >= 50 || head_y <= 0 || head_y >= 50 || hit.length != 1
			return true
		end
		false
	end
end

Game.new(true, false)