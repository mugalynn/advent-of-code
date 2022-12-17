def read_file
  nodes = []
  length = 0
  lines = File.readlines('terrain.txt')
  lines.each do |line|
    line = line.strip
    length = line.length
    line.each_char do |char|
      nodes.push(char)
    end
  end
  [nodes, length]
end

def display_terrain(nodes, length)
  n = 0
  while nodes[n]
    print nodes[n..(n + (length - 1))].join
    puts
    n += length
  end
end

def make_graph(nodes, length)
  graph = {}
  neighbors = []
  possible_starts = []

  starting_loc = nodes.index('S')
  nodes[starting_loc] = 'a'
  destination = nodes.index('E')
  nodes[destination] = 'z'

  nodes.each_with_index do |node, i|
    # check if neighbors to the right
    if (i % length) != (length - 1)
      if nodes[i + 1].ord < node.ord
        neighbors.push(i + 1)
      elsif nodes[i + 1].ord - node.ord <= 1
        neighbors.push(i + 1)
      end
    end
    # check if neighbors to the left
    if (i % length) > 0
      if nodes[i - 1].ord < node.ord
        neighbors.push(i - 1)
      elsif nodes[i - 1].ord - node.ord <= 1
        neighbors.push(i - 1)
      end
    end
    # check if neighbors above
    if i >= length && ((nodes[i - length].ord < node.ord) || (nodes[i - length].ord - node.ord <= 1))
      neighbors.push(i - length)
    end
    # check if neighbors below
    if i < nodes.length - length && ((nodes[i + length].ord < node.ord) || (nodes[i + length].ord - node.ord <= 1))
      neighbors.push(i + length)
    end
    possible_starts.push(i) if node == 'a'
    graph[i] = neighbors
    neighbors = []
  end
  print possible_starts
  path = path(graph, possible_starts, destination)
  print path.min_by { |_k, v| v }
end

def path(graph, possible_starts, destination)
  all_starts = {}
  possible_starts.each do |s|
    distance_from_start = {}
    open_list = [s]
    distance_from_start[s] = [s]
    while open_list.length > 0
      current = open_list[0]
      open_list.shift
      graph[current].each_with_index do |neighbor, _i|
        next if distance_from_start.include?(neighbor)

        distance_from_start[neighbor] = distance_from_start[current] + [neighbor]
        all_starts[s] = distance_from_start[destination].length - 1 if neighbor == destination
        open_list.push(neighbor)
      end
    end
  end
  all_starts
end

nodes, length = read_file
# display_terrain(nodes, length)
make_graph(nodes, length)
