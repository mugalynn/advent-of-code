def read_file
  graph = {}
  flow = {}

  lines = File.readlines('AOC_16_shorter_input.txt')
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
    graph[node] = neighbors
    flow[node] = flow_rate
  end

  [graph, flow]
end

def graph_with_paths(_graph, flow)
  graph = _graph
  graph_paths = {}
  graph_paths['AA'] = 'AA'
  distance = {}
  distance['AA'] = 0
  open_list = ['AA']
  pass_through = []
  while open_list.any?
    current = open_list[0]
    puts graph[current]
    graph[current].each do |neighbor, _i|
      unless graph_paths.include? neighbor
        if flow[neighbor] == 0 || flow[neighbor].nil?
          pass_through.push(neighbor)
        else
          graph_paths[neighbor] = graph_paths[current] + neighbor
          distance[neighbor] = 1 + distance[current]
          open_list.push(neighbor)
        end

      end
    end
  end

  def path
    v1 = 'AA'
    distance_from_start = {}
    open_list = [AA]
    distance_from_start[AA] = flow_rate[AA]

    while open_list.length > 0
      current = open_list[0]
      open_list.shift
      graph[current].each_with_index do |neighbor, _i|
        unless distance_from_start.include?(neighbor)
          distance_from_start[neighbor] = distance_from_start[current] + flow_rate[neighbor]
          open_list.push(neighbor)
        end
      end
    end
    all_starts
  end
end

graph, flow = read_file
graph_with_paths(graph, flow)

puts graph
puts flow
