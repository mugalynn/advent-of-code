def read_file
  sensors = []
  beacons = []
  sensor = []
  beacon = []
  lines = File.readlines('AOC_15_input.txt')
  lines.each do |line|
    line=line.split(":")
    sensor[0]=line[0].match(/[x][=](-?\d*)/)[1].to_i
    sensor[1]=line[0].match(/[y][=](-?\d*)/)[1].to_i
    beacon[0]=line[1].match(/[x][=](-?\d*)/)[1].to_i
    beacon[1]=line[1].match(/[y][=](-?\d*)/)[1].to_i
    sensors.append(sensor)
    beacons.append(beacon)
    sensor = Array.new
    beacon = Array.new
end
return [beacons, sensors]
end

def plot_sensors(sensors, beacons, board)
 
  sensors.each do |coordinate|
    location = coordinate[0]+$offset  + (coordinate[1]+$offset)*$width
    board[location] = 'S'
  end
  beacons.each do |coordinate|
    location = coordinate[0]+$offset + (coordinate[1]+$offset)*$width
    board[location] = 'B'
  end
#  draw_board(board)
  return board
end

def calculate_distance(sensors, beacons, board)
  sensors.each_with_index do |coordinate, i|
    delta_x = (coordinate[0]-beacons[i][0]).abs
    delta_y = (coordinate[1]-beacons[i][1]).abs
 # sensor  8, 7  beacon 2, 10
    manhattan_dist = delta_x + delta_y
    location = coordinate[0] +$offset  + (coordinate[1]+$offset)*$width
    board.each_with_index do |value, i|
      if (i-location).abs()/$width + ((i % $width) - (location % $width)).abs() < manhattan_dist && value == '.'
        board[i] = '#'
      end
    end
    
  end
  
 # draw_board(board)
  return board
end

def count_at_row(board, y)
beginning_of_row = (y+$offset)*$width
end_of_row = beginning_of_row +$width-1
i = beginning_of_row
count = 0
while i<end_of_row
 if board[i]!='.'
  count+=1
 end
 i+=1
end
return count
end


def draw_board(board)
  puts
  n=0
  while n<=($depth+$offset)
   print board[(n*$width)..($width-1)+(n*$width)].join
   puts
   n+=1
  end
end
  

def calculate_size(sensors, beacons)
  min_x=0
  max_x=0
  min_y=0
  max_y=0
  $offset = 30
  sensors.each do |coordinate|
    if coordinate[0]< min_x
      min_x = coordinate[0]
    end
    if coordinate[0] > max_x
      max_x = coordinate[0]
    end
    if coordinate[1]<min_y
      min_y = coordinate[1]
    end
    if coordinate[1]>max_y
      max_y = coordinate[1]
    end
  end

  beacons.each do |coordinate|
  if coordinate[0]< min_x
    min_x = coordinate[0]
  end
  if coordinate[0] > max_x
    max_x = coordinate[0]
  end
  if coordinate[1]<min_y
    min_y = coordinate[1]
  end
  if coordinate[1]>max_y
    max_y = coordinate[1]
  end
end
$max_x = max_x
$max_y = max_y
$min_x = min_x
$min_y = min_y
puts $width
puts $depth
$width = (max_x - min_x).abs + $offset + $offset
$depth = (max_y - min_y).abs + $offset

board = Array.new($width*($depth+$offset), '.')
return board
end

beacons, sensors = read_file
board = calculate_size(sensors, beacons)
plot_sensors(sensors, beacons, board)
board = calculate_distance(sensors, beacons, board)
puts count_at_row(board, 2000000)