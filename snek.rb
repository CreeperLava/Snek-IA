#https://github.com/han-gyeol/Genetic-Algorithm-Snake/blob/master/heuristic.js
# class for individual snakes

class Snek
	attr_accessor :id, :weights, :pos
	@@id_static = 0

	def initialize(pos_x, pos_y, weights)
		@id = @@id_static
		@@id_static += 1
		@pos = [[pos_x,pos_y]]
		@weights = weights
	end

	def move(key,food)
		old_head = head
		puts "YOU IDIOT TELL ME WHERE TO MOVE" if key == ""
		case key # and move head
			when "\e[A" # up
				@pos.unshift [@pos.first[0], @pos.first[1]+1]
			when "\e[B" # down
				@pos.unshift [@pos.first[0], @pos.first[1]-1]
			when "\e[C" # right
				@pos.unshift [@pos.first[0]+1, @pos.first[1]]
			when "\e[D" # left
				@pos.unshift [@pos.first[0]-1, @pos.first[1]]
		end
		snake_ate = (head == food)
		@pos.pop unless snake_ate # remove tail
		return snake_ate,old_head
	end

	def head
		return @pos.first
	end

	def tail
		return @pos.last
	end

	def size
		return @pos.length
	end

	def to_s
		return "S id:#{@id} p:#{@pos} w:#{@weights}"
	end

	def to_str
		return "S id:#{@id} p:#{@pos} w:#{@weights}"
	end
end
