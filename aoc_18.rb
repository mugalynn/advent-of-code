def read_file
  obsidian = Array.new
  lines = File.readlines('aoc_day_18_input.txt')
  lines.each_with_index do |line, i|
    vertices = line.strip
    vertices = vertices.split(',')
    vertices = vertices.map {|v| v.to_i}
    obsidian[i] = vertices
  end
  return obsidian
end

def flood_fill(obsidian)
  maxes  = [0, 0, 0]
  mins = [0, 0, 0] 
    obsidian.each do |v|
      maxes[0] = v[0] if v[0]> maxes[0] 
      mins[0] = v[0] if v[0]<mins[0]
      maxes[1] = v[1] if v[1]>maxes[1]
      mins[1] = v[1] if v[1]<mins[1]
      maxes[2] = v[2] if v[2]>maxes[2]
      mins[2] = v[2] if v[2]<mins[2] 
    end
  bounding_box = [maxes[0]+1, maxes[1]+1, maxes[2]+1]
  n = []
  n=[bounding_box]
  visited = []
  surface_area = 0
  while !n.empty? 
    air=n.pop
    if (obsidian.include? air)||(visited.include? air)
      next
    end
    if obsidian.include? [air[0]-1, air[1], air[2]]
      surface_area +=1
    elsif air[0]-1>=-1
       n.append([air[0]-1, air[1], air[2]])
    end
    if obsidian.include? [air[0]+1, air[1], air[2]]
      surface_area +=1
    elsif air[0]+1<=bounding_box[0] 
      n.append([air[0]+1, air[1], air[2]])
    end
    if obsidian.include? [air[0], air[1]-1, air[2]]
      surface_area +=1
    elsif air[1]-1>=-1
      n.append([air[0], air[1]-1, air[2]])
    end
    if obsidian.include? [air[0], air[1]+1, air[2]]
      surface_area +=1
    elsif air[1]+1<=bounding_box[1] 
      n.append([air[0], air[1]+1, air[2]])
    end
    if obsidian.include? [air[0], air[1], air[2]-1]
      surface_area +=1
    elsif air[2]-1>=-1
      n.append([air[0], air[1], air[2]-1])
    end
    if obsidian.include? [air[0], air[1], air[2]+1]
      surface_area +=1
    elsif air[2]+1<=bounding_box[2] 
      n.append([air[0], air[1], air[2]+1])
    end
    visited.append(air)
    end
 print surface_area
end


def surface_area(obsidian)
  surface_area = 0
  obsidian.each do |vertices|
    side_touching = 0
    obsidian.each do |v|
      if v==vertices
        next
      end
      if (v[0] == vertices[0] + 1 || v[0] == vertices[0] -1) && (v[1] == vertices[1] && v[2] == vertices[2])
        side_touching += 1
      elsif (v[1] == vertices[1] + 1 || v[1] == vertices[1] -1) && (v[0] == vertices[0] && v[2] == vertices[2])
        side_touching +=1
      elsif (v[2] == vertices[2] + 1 || v[2] == vertices[2] -1) && (v[0] == vertices[0] && v[1] == vertices[1])
        side_touching +=1
      end
    end
    surface_area += (6-side_touching)
  end
  return (surface_area)
end

obsidian = read_file
#print surface_area(obsidian)
flood_fill(obsidian)