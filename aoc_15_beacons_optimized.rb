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


def just_outside(sensors, beacons)
  coordinates_to_check={} 
  max = 4000000
  sensors.each_with_index do |sensor, i|
    puts "I am currently processing #{i}"
    delta_x = (sensor[0]-beacons[i][0]).abs
    delta_y = (sensor[1]-beacons[i][1]).abs
    manhattan_dist = delta_x + delta_y
    column = sensor[1]-manhattan_dist-1
    coordinates_to_check[[sensor[0], column]]=[sensor[0], column]
    column+=1
    n=1
    while column <= sensor[1]
      coordinates_to_check[[sensor[0]+n, column]]= [sensor[0]+n, column]
      coordinates_to_check[[sensor[0]-n, column]]=[sensor[0]-n, column]
      n+=1
      column+=1
    end
    while column <= sensor[1]+ manhattan_dist
      coordinates_to_check[[sensor[0]-n, column]]= [sensor[0]-n, column]
      coordinates_to_check[[sensor[0]+n, column]]=[sensor[0]+n, column]
      n+=1
      column+=1
    end
  coordinates_to_check[[sensor[0], sensor[1] + manhattan_dist+1]]= [sensor[0], sensor[1] + manhattan_dist+1]
  coordinates_to_check[[0,0]]=[0,0] 
  coordinates_to_check[[max, max]]=[max, max] 
  coordinates_to_check[[0, max]]=[0, max]
  coordinates_to_check[[max, 0]]=[max, 0]
  n+=1
  end 
  puts "I have to check #{coordinates_to_check.length}"
  return coordinates_to_check
end

def check_sensor_out_of_bounds (coordinates_to_check, sensors, beacons)
  max = 4000000
  counter = 0
  coordinates_to_check.each do |v, value|
    counter +=1
      sensors.each_with_index do |s, i|
        delta_x = (s[0]-beacons[i][0]).abs
        delta_y = (s[1]-beacons[i][1]).abs
        manhattan_dist = delta_x + delta_y
        if v[0]<=max && v[0]>=0 && v[1]<=max  && v[1]>=0 
          if v[0] == s[0] && v[1] == s[1]
            value = "S"
          elsif beacons[i][0] == v[0] && v[1] == beacons[i][0]
            value = "B"
          elsif (v[0]-s[0]).abs + (v[1]-s[1]).abs <= manhattan_dist && value == v
            value = "#"
          end
        elsif v[0]<0 || v[1]<0 || v[0]>max || v[1]>max
          value = "O"
        end 
      end
      if v == value
        return(v)
      elsif counter%100000==0
        puts "I have checked #{counter}"
      end
    end
    return("there is a problem!")
  end
 


beacons, sensors = read_file()
check_coords = just_outside(sensors, beacons)
puts check_sensor_out_of_bounds(check_coords, sensors, beacons)
