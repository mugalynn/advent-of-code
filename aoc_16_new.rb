def read_file
  graph = {}
  flow = {}

  lines = File.readlines('AOC_16_input.txt')
  lines.each do |line|
    holder = line.split('Valve ')
    # print holder
    node = holder[1].slice(0..1)
    flow_rate = line.scan(/\d/).join('').to_i
    if holder[1].include? 'valves'
      holder = holder[1].strip.split('valves ')
      neighbors = holder[1].split(',')
    elsif holder[1].include? 'valve'
      holder = holder[1].split('valve ')
      neighbors = holder[1].strip
    end
    neighbors = [neighbors] if neighbors.is_a? String
    neighbors = neighbors.each_with_index do |n, i| 
      neighbors[i]=n.strip
    end

    graph[node] = neighbors
    flow[node] = flow_rate
  end

  [graph, flow]
end

def floyd_warshall(graph, edge)
  #first create an matrix that assigns all distances as 0 (if self) or infinity (if not yet calculated)
  edge = edge
  dist = Hash.new
  graph.each do |k, v|
    dist[k] = Hash.new
      graph.each do |node, d|
      if node == k  
        dist[k][node] = 0 
      else dist[k][node] = Float::INFINITY
      end
     end

  end

  #next is used to create a shortest path tree -- not strictly necessary for the problem
#  nxt = Array.new(n){Array.new(n)}
  #assigns the weight of the edge 

edge.each do |u, v, w|
    # default distance is the direct distance between two vertices
    if dist[u].has_key? v
    dist[u][v] = w
    else puts v
    end
    # default next is the node being compared to
  #  nxt[u][v] = v
  end
  
  #this loop is the main part of the algorithm
  # for every possible starting location
  graph.each do |k, value|
    #and every possible vertice set
    graph.each do |i, v|
      graph.each do |j, d|
        #if the calculated distance is less than the default distance, replace it.
        if dist[i][j] > dist[i][k] + dist[k][j]
          dist[i][j] = dist[i][k] + dist[k][j]
       #   nxt[i][j] = nxt[i][k]
        end
      end
    end
 end

  
 # puts "pair     dist    path"
 # graph.each do |i, v|
  #  graph.each do |j, d|
   #   next  if i==j
     #  puts "%s -> %s  %4d" % [i, j, dist[i][j]]
   # end
 # end
  return dist
end

def best_path(path_list)
  best_flow= 0
  path_list = path_list.sort_by{|path, flow| flow}
  path_list = path_list.reverse
  n=1
  puts "I have to analyze #{path_list.length}"
  path_list.each_with_index do |path, index|
    path_list.each_with_index do |p, i|
      intersection = path[0].intersection(p[0])
      if intersection.length>1
        next
      elsif path[1]+p[1] > best_flow
        best_flow = path[1]+p[1]
        print "current best_flow is #{best_flow}"
      elsif path[1]+p[1] < best_flow
        break  
      end
end
end
print "this is my best #{best_flow}"
end

def create_matrix(graph)
  edge = Array.new
  graph.each do |key, value|
    value.each do |v, index|
      one_edge = [key, v, 1]
      edge << one_edge
    end
  end
return (edge)
end

def paths_that_matter (graphs, flow, dist)
  reduced_graph = {} 
  nodes_of_interest = flow.select {|key, value| value > 0 || key == 'AA'}
  nodes_of_interest.each do |key, value|
    reduced_graph[key]=Hash.new
    nodes_of_interest.each do |k, v|
      if k !=key
      reduced_graph[key][k] = dist[key][k]+1
      end
    end
  end

  time = 26
  
  start = 'AA'
  open_list = [['AA',[], 26, 0]]
  path_list = []
  total_flow = 0
  maximum_flow = 0
  while !open_list.empty?
   current, history, time_remaining, total_flow = open_list.pop
    if history.include? current
      next
    end
    elapsed_time = reduced_graph[current][history.last]
    elapsed_time = 0 if elapsed_time.nil?
    time_remaining = time_remaining - elapsed_time
    if time_remaining <= 0
      path_list.append([history, total_flow])
      next
    end
    total_flow = total_flow + time_remaining*flow[current]  
    if total_flow > maximum_flow
      maximum_flow = total_flow
    end
    reduced_graph[current].each do |k, v|
      new_history = Marshal.load( Marshal.dump(history) )
      new_history.append(current)
      open_list.append([k, new_history, time_remaining, total_flow])
    end
    end 
    puts maximum_flow 
    return(path_list) 
end



graph, flow = read_file
#print graph
edge = create_matrix(graph)
dist = floyd_warshall(graph, edge)
path_list = paths_that_matter(graph, flow, dist)
best_path(path_list)