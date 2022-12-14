def read_file
  nodes = Array.new 
  length=0

  lines = File.readlines("terrain.txt")
  lines.each do |line|
    line=line.strip
    length=line.length
    line.each_char do |char|
      nodes.push(char)
    end
  end
  return nodes, length
end

def display_terrain(nodes, length)
  n=0
  while nodes[n]
    print nodes[n..(n+(length-1))].join
    puts
    n+=length
  end
end

def make_graph (nodes, length)
  graph = Hash.new
  neighbors = Array.new
  possible_starts = Array.new

  starting_loc = nodes.index("S")
  nodes[starting_loc]="a"
  destination = nodes.index("E")
  nodes[destination]="z"

  nodes.each_with_index do |node, i|
    #check if neighbors to the right
    if (i%length)!=(length-1)
        if nodes[i+1].ord < node.ord
          neighbors.push(i+1)
        elsif nodes[i+1].ord - node.ord <=1
          neighbors.push(i+1)
        end
    end
    #check if neighbors to the left
    if (i%length)>0
      if nodes[i-1].ord < node.ord
        neighbors.push(i-1)
      elsif nodes[i-1].ord - node.ord <=1
        neighbors.push(i-1)
      end
    end
    #check if neighbors above
    if i >=length
      if (nodes[i-length].ord < node.ord) || (nodes[i-length].ord - node.ord <=1)
        neighbors.push(i-length)
      end
    end
    #check if neighbors below
    if (i<nodes.length-length)
      if (nodes[i+length].ord < node.ord) || (nodes[i+length].ord - node.ord <=1)
        neighbors.push(i+length)
      end
    end
    if node == "a"
    possible_starts.push(i)
    end  
    graph[i]=neighbors
    neighbors = Array.new
  end
  print possible_starts
  path = path(graph, possible_starts, destination)
  print path.min_by {|k, v| v}
end

def path(graph, possible_starts, destination)
  all_starts = Hash.new
  possible_starts.each do |s|
  distance_from_start = Hash.new
  open_list = [s]
  distance_from_start[s] = [s]
  while open_list.length > 0
    current = open_list[0]
    open_list.shift
    graph[current].each_with_index do |neighbor, i|
      unless distance_from_start.include?(neighbor)
        distance_from_start[neighbor] = distance_from_start[current] + [neighbor]
        if neighbor == destination
          all_starts[s] = distance_from_start[destination].length-1
        end
        open_list.push(neighbor)
      end
    end
    end
  end
  return all_starts
end





nodes, length = read_file
#display_terrain(nodes, length)
make_graph(nodes, length)

