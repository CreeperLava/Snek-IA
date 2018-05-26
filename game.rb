require './snek'
require 'io/console'

# class for the game's logic and display
# take as constructor a boolean to activate or not the display of the game

# y
# *----------------*
# |                |
# |      ~~~^      |
# |                |
# |              x |
# *----------------* x
#

class Game
  attr_accessor :size_x, :size_y, :food, :score, :snek, :moves_since_food

  def initialize(display, ai, snek)
    @display = display # is display of the game activated or not
    @ai = ai # is snek controlled by an AI or a human
    @size_x = 50 # initial size of game grid
    @size_y = 50 # coordinates 0,y, 50,y and 0,x, x,50 are borders
    @scale = @size_x/@size_y  #scale of the window, used for now in heuristic
    @snek = snek

    @moves_since_food = 0

    @score = 0

    @rng = Random.new

    # create size_x*size_y matrix
    # init to ' ' except for borders (*,|,_), food(x) and snek head (^)
    # create array to store list of free tiles -> avoid looking up the whole matrix

    @board = Array.new(@size_x, ' ') { Array.new(@size_y, ' ') } # store the game's board in a matrix, stored line by line. board[2][14] -> line 2, column 14
    init_snek
    new_food

    @just_ate = false
    @last_key_pressed = ''

    unless @ai
      play
      @read_input = Thread.new do
        loop do
          read_char
          sleep 0.2
        end
      end
    end
    # if ai, heuristics takes over and plays the frames one by one itself
  end

  def init_snek
    return if game_over?
  	h = @snek.head
  	@board[h[0]][h[1]] = '^'
  end

  def free_tile?(x, y)
    return @board[x][y] == ' '
  end

  # play the game
  def play
    # check if game is over each frame
    next_frame @last_key_pressed until game_over?
  end

  def new_food
  	i = @rng.rand((@size_x-1)*(@size_y-1) - @snek.size - 1) # i-ième case du board

	0.upto(@size_x) do |x|
		0.upto(@size_y) do |y|
			if i <= 0 && @board[x][y] == ' '
				@board[@food[0]][@food[1]] = ' ' unless @food.nil?
				@food = [x,y]
				@board[x][y] = 'x'
				return
			else
				i -= 1
			end
		end
	end
  end

  # for each frame, run game logic
  def next_frame move
    if @ai
      # await the AI's decision -> call a method from heuristic
      move_snek move
    else
      read_char # get key pressed
      move_snek move
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

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    if input == "\e[A" || input == "\e[B" || input == "\e[C" || input == "\e[D"
      @last_key_pressed = input
    end
  end

  # move snek : remove tail, move head
  # edit free tiles
  # edit matrix
  # edit snek pos
  def move_snek move
    @just_ate,old_head = @snek.move(move,food)

    return if game_over?
    @board[old_head[0]][old_head[1]] = ' '
    @board[@snek.head[0]][@snek.head[1]] = '^' # move head to new position

    # if snek just ate, it grew, so leave tail
    @score -= 1 if @moves_since_food > 100
  	@moves_since_food += 1
    if @just_ate
		puts "J'AI MANGE LOL"
      @score += 1
      @moves_since_food = 0
      new_food
      @just_ate = false
	  @board[@snek.tail[0]][@snek.tail[1]] = ' ' # remove tail
    end

    @board[@snek.pos[1][0]][@snek.pos[1][1]] = '~' unless @snek.pos.length == 1
  end

  def draw!
    # check if it is possible to keep the StringIO from frame to frame and just edit what changed, then rewind and read
    @size_x.times do |x|
      puts @board[x].join
    end

   # str.rewind
   # puts str.read
   # str.rewind
   # str
  end

  def game_over?
    head_x = @snek.head[0]
    head_y = @snek.head[1]
    hit = @snek.pos.select { |e| e == [head_x, head_y] } # we hit ourselves if there is another tile of the snek with the coordinates of the head
    # if we hit a wall or ourselves, return true
    if head_x < 0 || head_x >= @size_x || head_y < 0 || head_y >= @size_y || hit.length != 1 || @score < 0
      return true
    end
    false
  end

  def distance_from_food
    return Math.sqrt(((@snek.head[0] - @food[0])**2)+((@snek.head[1] - @food[1])**2)).to_f
  end

  def squareness
  	xmax = @snek.head[0]
  	ymax = @snek.head[1]
  	xmin = @snek.head[0]
  	ymin = @snek.head[1]
  	blankcount = 0

  	1.upto(@snek.size-1) do |i|
  		xmax = (xmax < @snek.pos[i][0])? @snek.pos[i][0] : xmax;
      	xmin = (xmin > @snek.pos[i][0])? @snek.pos[i][0] : xmin;
      	ymax = (ymax < @snek.pos[i][1])? @snek.pos[i][1] : ymax;
		ymin = (ymin > @snek.pos[i][1])? @snek.pos[i][1] : ymin;
  	end

  	row = (ymin/@scale)
  	col = (xmin/@scale)

  	row.upto(ymax/@scale-1) do |r|
  		col.upto(xmax/@scale-1) do |c|
  			blankcount += 1 if @board[row][col] == ' '
  		end
  	end

  	return blankcount / @snek.size*2
  end

  def compactness
  	count = 0.0
  	1.upto(@snek.size-1) do |i|
  		1.upto(@snek.size-1) do |j|
  			if ((@snek.pos[i][0] + @scale == @snek.pos[j][0] && @snek.pos[i][1] == @snek.pos[j][1]) ||
  			 (@snek.pos[i][0] - @scale == @snek.pos[j][0] && @snek.pos[i][1] == @snek.pos[j][1]) ||
  			 (@snek.pos[i][0] == @snek.pos[j][0] && @snek.pos[i][1] + @scale == @snek.pos[j][1]) ||
  			 (@snek.pos[i][0] == @snek.pos[j][0] && @snek.pos[i][1] - @scale == @snek.pos[j][1]))
          		count += 1
          	end
  		end
  		if ((@snek.pos[i][0] + @scale == @snek.head[0] && @snek.pos[i][1] == @snek.head[1]) ||
  		 (@snek.pos[i][0] - @scale == @snek.head[0] && @snek.pos[i][1] == @snek.head[1]) ||
  		 (@snek.pos[i][0] == @snek.head[0] && @snek.pos[i][1] + @scale == @snek.head[1]) ||
  		 (@snek.pos[i][0] == @snek.head[0] && @snek.pos[i][1] - @scale == @snek.head[1]))
       		count += 1
		end
  	end
  	1.upto(@snek.size-1) do |j|
      if ((@snek.head[0] + @scale == @snek.pos[j][0] && @snek.head[1] == @snek.pos[j][1]) ||
       (@snek.head[0] - @scale == @snek.pos[j][0] && @snek.head[1] == @snek.pos[j][1]) ||
       (@snek.head[0] == @snek.pos[j][0] && @snek.head[1] + @scale == @snek.pos[j][1]) ||
       (@snek.head[0] == @snek.pos[j][0] && @snek.head[1] - @scale == @snek.pos[j][1]))
        	count += 1
      end
  	end
	return count/@snek.size
  end

  def food_ahead
    return (@snek.head[0] == @food[0] || @snek.head[1] == @food[1]) ? 1 : 0
  end

  def dead_end
  	return (@snek.head[0] == @size_x-1 || @snek.head[0] == 0 || @snek.head[1] == @size_y-1 || @snek.head[1] == 0) ? 1 : 0
  end
end
