class CircularList
	class Node
		attr_accessor :next, :data, :original_index
		def initialize data, original_index
			self.data = data
      self.original_index = original_index
			self.next = nil
		end
	end

	attr_accessor :head, :current, :length

	# Initialize an empty lits.
	# Complexity: O(1).
	def initialize
		self.head   = nil
		self.length = 0
	end


	# Inserts a new item at the end of the list.
	# Complexity: O(n).
	def insert data, original_index
		return insert_next(nil, data, original_index)       if (self.length == 0)
		return insert_next(self.head, data, original_index) if (self.length == 1)

		# We have to find the last node and insert the
		# new node right next to it.
		self.current = head
		i = 0;
		while ((i += 1) < self.length)
			move_next
		end

		# current == "tail".
		return insert_next(self.current, data, original_index)
	end

	# Inserts a new node next to the specified node.
	# Complexity: O(1).
	def insert_next prev_node, data, original_index
		new_node = Node.new data, original_index
		if self.length == 0
			self.head = new_node.next = new_node
		else
			new_node.next = prev_node.next
			prev_node.next = new_node
		end
		self.length += 1
	end

	# Removes an item from the list.
	# Complexity: O(n).
	def remove node
		return nil unless node
		return nil unless self.length > 0

		# head?
		return remove_next node if (self.length == 1)

		# Find the precedent node to the node we 
		# want to remove.
		prev = nil
		self.current = self.head
		while ((prev = self.move_next) != node)
		end
		remove_next prev
	end


  # Here
  def move original_index
    return nil unless original_index
    return nil unless self.length>0
    node, prev = self.find_node_and_prev(original_index)
    value = node.data
    original_value = node.data
    if value<0
      value = value.remainder(self.length-1)
      value += self.length-1
    elsif value>0
      value = value%(self.length-1)
    end
    remove_next prev
    (value).times {prev=self.move_next}
    insert_next(prev, original_value, original_index)  


  
  end

	# Removes the node that is next to the specified node.
	# Complexity: O(1).
	def remove_next prev_node
		return nil unless self.length > 0

        unless prev_node
            # remove head.
            self.head = self.head.next
        else
            if prev_node.next == prev_node
                self.head = nil
            else
                old = prev_node.next
                prev_node.next = prev_node.next&.next
                if (old == self.head)
                    self.head = old.next
                end
            end
        end

    	self.length -= 1
	end


	# Removes all items form the list.
	# Complexity: O(n).
	def clear
		while self.length > 0
			remove self.head
		end
	end

	# Moves to the next node.
	def move_next
		self.current = self.current&.next
	end

	# Conviniece methods

	# Traverse all of the elements from the list
	# without wrapping around. 
	# (Starts from the head node and halts when 
	# gets back to it.) 
	def full_scan
		return nil unless block_given?

		self.current = self.head
		# If you are not familiar with ruby this
		# is the recommended way to write: do { p } while (q);
		loop do
			yield self.current
			break if (move_next == self.head)
		end
	end

	# Finds the first occurence that matched
	# the given predicate.
	# Complexity: O(n).

  def iterate_from_start (node, iterator)
		self.current = node
    iterator.times {move_next}
    return self.current.data
	end

	def find_node_and_prev original_index

		self.current = self.head
    prev = self.current
    move_next
		loop do
			return [self.current, prev] if (self.current.original_index == original_index)
      prev = self.current
			move_next
		end
	end

  def find_node_by_value data

		self.current = self.head
    prev = self.current
    move_next
		loop do
			return [self.current] if (self.current.data == data)
      prev = self.current
			move_next
		end
	end

	# Prints the contents of the list.
	# Complexity: O(n).
	def print_list
		if self.length == 0
			puts "empty"
		else
			self.full_scan { |item| print item.data }
		end
	end

  def return_value (node)
    if self.length == 0
      puts "empty"
    else
      self.current = self.head
      prev = self.current
      move_next
		  loop do
			  return [self.current.data] if (self.current.node == node)
        prev = self.current
			move_next
		  end
	  end
  end

end

def shuffle_list (sequence, starting_sequence)
  starting_sequence.each_with_index do |v, i|
    sequence.move(i)
  end
  sequence
end

 def modulo_sum (sequence)
  nums=[]
  modulo = [1000%sequence.length, 2000%sequence.length, 3000%sequence.length]
  start = sequence.find_node_by_value(0)
  modulo.each_with_index do |m, i|
    value = sequence.iterate_from_start(start[0], m) 
    nums[i]=value
  end
print nums
print nums.sum
end

def encryption_key(sequence, starting_sequence)
  expanded_sequence = starting_sequence.map! {|v| v *= 811589153 }
  print expanded_sequence
  expanded = CircularList.new
  expanded_sequence.each_with_index do |value, index|
    expanded.insert(value,index)
  end
  10.times { expanded = shuffle_list(expanded, expanded_sequence)}
  expanded
end


def read_file
  starting_sequence = []
  lines = File.readlines('aoc_19_input.txt')
  lines.each do |l|
    l= l.strip
    l = l.to_i
    starting_sequence.push(l)
  end
  #print starting_sequence

  sequence = CircularList.new
  starting_sequence.each_with_index do|value, index|
    sequence.insert(value,index)
  end

  [sequence, starting_sequence]

end

sequence, starting_sequence = read_file
#First Part
#sequence = shuffle_list(sequence, starting_sequence)
#modulo_sum(sequence)
#Second Part
sequence = encryption_key(sequence, starting_sequence)
modulo_sum(sequence)




