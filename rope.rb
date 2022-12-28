$width
$min_x
$min_y
$max_y
$visualize = true

def read_file
  lines = File.readlines('rope_path.txt')
  path = []
  direction = Array.new
  lines.each do |line|
    direction = line.strip.split" "
    direction[1] = direction[1].to_i
    direction[0] = direction[0].strip
    path.append(direction)
  end
  path
end

def calculate_width (path)
 
  path = path
  width = 0
  $min_x = 0
  $max_x = 0
  depth = 0
  $min_y = 0
  $max_y = 0
  path.each do |i, v|
  #calculate width
    if i == 'R'
      width += v 
      if width > $max_x
        $max_x = width
      end
    elsif i == 'L'
      width -= v
      if width < $min_x
        $min_x = width
      end
    elsif i == 'U'
      depth += v
      if depth > $max_y
      $max_y = depth
      end
    elsif i == 'D'
      depth -= v
      if depth < $min_y
        $min_y =depth
      end
    end
    
  end
  adjustment = 5000
  $min_x = $min_x + adjustment/2
  width = ($max_x-$min_x) 
  $width = width+1 + adjustment
  $depth = ($max_y - $min_y) + adjustment
  $min_y = $min_y - adjustment/2
  puts "the min x = #{$min_x} and the max x = #{$max_x}. The min depth = #{$min_y} and max height is #{$max_y}"
end

def move_rope (path)
  array_board = Array.new(($depth+1)*$width, '.')
  positions = Array.new(10, 0)
  starting_location = positions[0]-$min_x -($min_y*$width)
  #array_board[starting_location]='s'
  #display_grid(array_board)
  #now that I know the width, I can move the head around.... (and tail)
  path.each_with_index do |v, i|
    array_board, positions = move_head_longer(array_board, positions, v)
  end
 # display_grid(array_board)
  count(array_board)
end


def move_head_longer(array_board, positions, v)
  
  v[1].times do
    puts "do I move?"
    if v[0] == 'R'
      positions[0] += 1
    elsif v[0]== 'L'
      positions[0] -= 1
    elsif v[0] == 'U'
      positions[0] += $width
    elsif v[0] == 'D'
      positions[0] -= $width
    end
   # array_board[(positions[0] - $min_x)-($min_y*$width)] = 'h'
    n=1
    while n<10
    array_board, positions = move_next(array_board, positions, n)
    n+=1
    end
  #  display_grid(array_board)
  end
  return [array_board, positions]

end

def move_next(array_board, positions, n)
  diff = positions[n-1]-positions[n]
  sign = diff <=> 0
  #check if same row
  if diff.abs() >= 2 && ((positions[n-1]-$min_x)/($width) == (positions[n]-$min_x)/($width)) 
    positions[n] += sign*1
  #check if same column
  elsif (diff/$width).abs() >= 2 && ((positions[n-1]-$min_x)%($width) == (positions[n]-$min_x)%($width))
    positions[n] += sign*$width
 #check if touching
  elsif diff.abs() < 2 && ((positions[n-1]-$min_x)/$width == (positions[n]-$min_x)/$width)
    positions[n]
  elsif (diff/$width).abs() < 2 && (positions[n-1]-$min_x)%($width) == (positions[n]-$min_x)%($width)
    positions[n]
  elsif  diff.abs() == $width-1 || diff.abs() == $width+1
      positions[n]
  # move diagonals
  elsif (positions[n-1]-$min_x)%($width) > (positions[n]-$min_x)%($width)
      positions[n] += sign*$width +1
  elsif (positions[n-1]-$min_x)%($width) < (positions[n]-$min_x)%($width)
      positions[n] += sign*$width -1
  end
 # puts "blah"
  if n == 9
  array_board[(positions[n]-$min_x)-($min_y*($width))]=n
  end
  # this adjustment does not work out in the bottom left corner of the grid when x and y are both negative.
 # puts "BLAH"
  return [array_board, positions]
end


def move_head(array_board, move, current, tail_current)
  max_x= $max_x
  v=move
  v[1].times do
  if v[0] == 'R'
    current += 1
  elsif v[0]== 'L'
    current -= 1
  elsif v[0] == 'U'
    current += $width
  elsif v[0] == 'D'
    current -= $width
  end
 array_board[(current - $min_x)-($min_y*$width)] = 'h' if $visualize == true
  $max_x = max_x
  array_board, tail_current, current = move_tail(array_board, tail_current, current)
  end
  return [array_board, tail_current, current]

end

def move_tail(array_board, tail_current, current)
  diff = current-tail_current
  sign = diff <=> 0
  #check if same row
  if diff.abs() >= 2 && ((current-$min_x)/($width) == (tail_current-$min_x)/($width)) 
    tail_current += sign*1
  #check if same column
  elsif (diff/$width).abs() >= 2 && ((current-$min_x)%($width) == (tail_current-$min_x)%($width))
    tail_current += sign*$width
 #check if touching
    elsif diff.abs() < 2 && ((current-$min_x)/$width == (tail_current-$min_x)/$width)
    tail_current
    elsif (diff/$width).abs() < 2 && (current-$min_x)%($width) == (tail_current-$min_x)%($width)
    tail_current
    elsif  diff.abs() == $width-1 || diff.abs() == $width+1
      tail_current
  # move diagonals
    elsif (current-$min_x)%($width) > (tail_current-$min_x)%($width)
      tail_current += sign*$width +1
    elsif (current-$min_x)%($width) < (tail_current-$min_x)%($width)
      tail_current += sign*$width -1
    end
 # puts "blah"
  array_board[(tail_current-$min_x)-($min_y*($width))]='t'
  # this adjustment does not work out in the bottom left corner of the grid when x and y are both negative.
 # puts "BLAH"
  display_grid(array_board) if $visualize
  return [array_board, tail_current, current]
end

def count(array_board)
  visited = array_board.select {|i| i == 9}
  total = visited.length
  puts total
end

def display_grid(board)
  puts
  n=$depth
  while n >=0
   print board[(n*$width)..($width-1)+(n*$width)].join
   puts
   n-=1
  end
end

#guess was 6856 and was too high
#guess was 6638 and was too high
# actual answer is 6269

path = read_file
calculate_width(path)
move_rope(path)
