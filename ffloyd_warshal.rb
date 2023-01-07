def floyd_warshall(n, edge)
  #first create an matrix that assigns all distances as 0 (if self) or infinity (if not yet calculated)
  dist = Array.new(n){|i| Array.new(n){|j| i==j ? 0 : Float::INFINITY}}
  #next is used to create a shortest path tree -- not strictly necessary for the problem
  nxt = Array.new(n){Array.new(n)}
  #assigns the weight of the edge 

  edge.each do |u,v,w|
    # default distance is the direct distance between two vertices
    dist[u-1][v-1] = w
    # default next is the node being compared to
    nxt[u-1][v-1] = v-1
  end
  
  #this loop is the main part of the algorithm
  # for every possible starting location
  n.times do |k| 
    #and every possible vertice set
    n.times do |i|
      n.times do |j|
        #if the calculated distance is less than the default distance, replace it.
        if dist[i][j] > dist[i][k] + dist[k][j]
          dist[i][j] = dist[i][k] + dist[k][j]
          nxt[i][j] = nxt[i][k]
        end
      end
    end
  end
  
  puts "pair     dist    path"
  n.times do |i|
    n.times do |j|
      next  if i==j
      u = i
      path = [u]
      path << (u = nxt[u][j])  while u != j
      path = path.map{|u| u+1}.join(" -> ")
      puts "%d -> %d  %4d     %s" % [i+1, j+1, dist[i][j], path]
    end
  end
end

n = 4
edge = [[1, 3, -2], [2, 1, 4], [2, 3, 3], [3, 4, 2], [4, 2, -1]]
floyd_warshall(n, edge)