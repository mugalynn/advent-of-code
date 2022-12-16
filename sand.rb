def read_file
  rocks = Hash.new
  rock_path = Array.new 

  lines = File.readlines("rocks.txt")
  lines.each_with_index do |line, index|
    line=line.strip
    rock_path=line.split(" -> ")
    rock_path.map! do |r|
      r = r.split(",")
      r.map!(&:to_i)
    end 
    rocks[index]=rock_path
    rock_path=Array.new
    end
    return rocks
end

def neighbors(grid_array, width, starting_loc)
  
  graph = Hash.new
  neighbors = Array.new
  v1=starting_loc
  grid_array.each_with_index do |node, i|
    if node == "."
      if (i<grid_array.length-width) 
        if i%width<width &&grid_array[i+width+1] == "." #check to the bottom right
          neighbors.push(i+width+1)
        end
        if i%width>0 && grid_array[i+width-1] =="." #check to the bottom left
          neighbors.push(i+width-1)
        end
        if grid_array[i+width]=="." #check below
            neighbors.push(i+width)
        end       
      end  
      graph[i]=neighbors
      neighbors = Array.new
    end
  end
path(graph,v1, grid_array, width)  
end

def grid(rocks)
  
  max_v = 0
  min_v = 100000
  maximum = 0
  rocks.each do |k, value|
    value.each do |v, m|
      if v > max_v
        max_v=v
      end
      if v < min_v
        min_v=v
      end
      if m>maximum
        maximum=m   
      end 
    end
  end
#puts "#{min_v} to #{max_v}" 
width = maximum*3
offset = width/3
depth = maximum*4
grid_array = Array.new(width*depth, ".")
rocks.each do |k, value|
  value.each do |v, m|
    x=((m)*(width))+(v-min_v+offset)
    grid_array[x]="x"
  end
  value.each_with_index do |path, i|
  if value[i+1]
    if path[0] == value[i+1][0]
      length = value[i+1][1]-path[1]
      n=0
      while n<length.abs
        shift=n*(length<=>0)
        x = (path[1]+shift)*width + (path[0]-min_v+offset)
        grid_array[x]="x"
        n+=1
      end 
    elsif path[1] == value[i+1][1]
      length = value[i+1][0]-path[0]
      n=0
      while n<length.abs
      shift=n*(length<=>0)
        x = (path[1])*width + (path[0]-min_v+shift+offset)
        grid_array[x]="x"
        n+=1
      end
    end
  end
end
end
grid_array.each_with_index do |v, i|
  if (i>grid_array.length-width-1)
  grid_array[i]="x"
  end
end
starting_loc=offset+(500-min_v)
neighbors(grid_array, width, starting_loc)
end



def path (graph, v1, grid_array, width)
  open_list=[v1]
  sand=Array.new
  sand_count=0
  while open_list.length > 0
    current=open_list[open_list.length-1]
    c=0
    graph[current].each_with_index do |neighbor, i|
      unless sand.include?(neighbor)
        open_list.push(neighbor)
      end
      if sand.include?(neighbor)
        c+=1
      end
    end
    if (graph[current].length == 0 ||graph[current].length == c)
      sand.push(current)
      grid_array[current]="o"
      sand_count+=1
      open_list.pop
    end
  end
  display_grid(grid_array, width)
  puts "total sand is #{sand_count}"
end
    
def display_grid(grid_array, width)
  n=0
  while grid_array[n] do
    print grid_array[n..(n+(width-1))].join
    puts
    n+=(width)
  end
end

rocks = (read_file)
grid(rocks)
#answer is 625