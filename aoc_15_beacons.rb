$offset = 30

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
def search_area(sensors, beacons)
  beacon=[]
  y=0
  while beacon[0].nil?
    beacon[0], beacon[1] =check_for_beacon(sensors,beacons,y)
    y+=1
    if y==4000000
      break
    end
  end
  return beacon
end

def just_outside(sensors, beacons)
  coordinates_to_check=[]
  n=0
  sensors.each_with_index do |sensor, i|
    delta_x = (sensor[0]-beacons[i][0]).abs
    delta_y = (sensor[1]-beacons[i][1]).abs
    manhattan_dist = delta_x + delta_y
    #coordinates_to_check.append([sensor[0]+manhattan_dist, sensor[1]])
    #coordinates_to_check.append([sensor[0]-manhattan_dist, sensor[1]])
    #coordinates_to_check.append([sensor[0], sensor[1]+manhattan_dist])
    coordinates_to_check.append([sensor[0], sensor[1]-manhattan_dist])
    column = sensor[0]-manhattan_dist
    
    first_x = coordinates_to_check[n][0]+1
    first_y = coordinates_to_check[n][1]+1
    second_x = coordinates_to_check[n][0]-1
    second_y = coordinates_to_check[n][1]+1
    coordinates_to_check.append([first_x, first_y])
    coordinates_to_check.append([second_x, second_y])
    n+=1
    column +=1
    while column <= sensor[0]
      first_x = coordinates_to_check[n][0]+1
      first_y = coordinates_to_check[n][1]+1
      n+=1
      second_x = coordinates_to_check[n][0]-1
      second_y = coordinates_to_check[n][1]+1
      coordinates_to_check.append([first_x, first_y])
      coordinates_to_check.append([second_x, second_y])
      n+=1
      column+=1
    end
  while column < sensor[1]+ manhattan_dist
    first_x = coordinates_to_check[n][0]-1
    first_y = coordinates_to_check[n][1]+1
    n+=1
    second_x = coordinates_to_check[n][0]+1
    second_y = coordinates_to_check[n][0]+1
    n+=1
    column +=1
  end
  coordinates_to_check.append([sensor[0], sensor[1] + manhattan_dist])
  n+=1
end 
return sensor_out_of_bounds
end

def check_sensor_out_of_bounds (sensor_out_of_bounds, sensors, beacons, y)
  begin_x = 0
  end_of_x = 4000000
  checked = hash.New
  sensors.each do |s, i|
    delta_x = (s[0]-beacons[i][0]).abs
    delta_y = (s[1]-beacons[i][1]).abs
    manhattan_dist = delta_x + delta_y
    coordinates_to_check.each_with_index |v, index|
      if v[0]<4000000 && v[1]<4000000
        if v[0] == s[0] && v[1] == s[1]
          checked[index] = "S"
        elsif beacons[i][0] == v[0] && v[1] == beacons[i][0]
          checked[index] = "B"
        elsif (v[0]-s[0]).abs + (v[1]-s[1]).abs <= manhattan_dist && checked[index].nil?
          checked[index] = "#"
        end
      else
        checked[index] = "O"
      end 
    end
  end
  coordinates_to_check.each_with_index |v, index|
    if checked[index].nil?
      return (v)
    end
end


        


def check_for_beacon(sensors, beacons, y)
  row = {}
  count = 0
  begin_x = 0
  end_of_x = 4000000
  sensors.each_with_index do |sensor, i|
    delta_x = (sensor[0]-beacons[i][0]).abs
    delta_y = (sensor[1]-beacons[i][1]).abs
 # sensor  8, 7  beacon 2, 10
    manhattan_dist = delta_x + delta_y
  
    m = begin_x
    while m<(end_of_x)
    if m == sensor[0] && sensor[1]==y
      row[m] = 'S'
    elsif m == beacons[i][0] && beacons[i][1]==y
      row[m] = 'B'
    elsif ((m-sensor[0]).abs()+(y-sensor[1]).abs() <= manhattan_dist) && row[m] != "B" && row[m] != "S"
        row[m]='#'
    end
   
    m+=1
  end
end
i=0
while i<20
  if row[i].nil?
    return [i, y]
  end
  i+=1
end

end

def check_sensor(sensors, beacons, y)
  row = {}
  count = 0
  begin_x = 0
  end_of_x = 20
  sensors.each_with_index do |sensor, i|
    delta_x = (sensor[0]-beacons[i][0]).abs
    delta_y = (sensor[1]-beacons[i][1]).abs
 # sensor  8, 7  beacon 2, 10
    manhattan_dist = delta_x + delta_y
  
    m = begin_x
    while m<(end_of_x)
    if m == sensor[0] && sensor[1]==y
      row[m] = 'S'
    elsif m == beacons[i][0] && beacons[i][1]==y
      row[m] = 'B'
    elsif ((m-sensor[0]).abs()+(y-sensor[1]).abs() <= manhattan_dist) && row[m] != "B" && row[m] != "S"
        row[m]='#'
    end
   
    m+=1
  end
end
row=row.sort.to_h

puts row.length-row.select{|k,v| v=="B"}.length
end


def calculate_distance(sensors, beacons, board)
  sensors.each_with_index do |coordinate, i|
    delta_x = (coordinate[0]-beacons[i][0]).abs
    delta_y = (coordinate[1]-beacons[i][1]).abs
 # sensor  8, 7  beacon 2, 10
    manhattan_dist = delta_x + delta_y
    location = coordinate[0] +$offset  + (coordinate[1]+$offset)*$width
    board.each_with_index do |value, i|
      if (i-location).abs()/$width + ((i % $width) - (location % $width)).abs() <= manhattan_dist && value == '.'
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

$width = (max_x - min_x).abs + 2 * $offset
$depth = (max_y - min_y).abs + $offset
end

beacons, sensors = read_file()
puts search_area(sensors, beacons)
#check_sensor(sensors, beacons, 2000000)
