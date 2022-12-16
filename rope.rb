def read_file
  lines = File.readlines('rope_shorter.txt')
  path = Array.new
  direction = Array.new
  lines.each do |line|
    direction = line.strip.split" "
    direction[1] = direction[1].to_i
    direction[0] = direction[0].strip
    path.push(direction)
  end
  print path
end

def create_grid
  board = Array.new(25, 0)
end

def display_grid (board)
  puts
   print board[0..4]
   puts
   print board[5..9]
   puts
   print board[10..14]
   puts
   print board[15..19]
   puts
   print board[20..24]
   puts
end

def flip_switch (location, board)
board[location] = 1
end

read_file
board = create_grid
flip_switch(20, board) 
display_grid(board)