def read_file
  nodes = []
  length = 0
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

def path
  v1 = 'AA'
end

graph, flow = read_file

puts graph
puts flow
