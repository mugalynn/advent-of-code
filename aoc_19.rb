class Blueprint

  def initialize (id_number, ore_cost, clay_cost, obsidian_cost, geode_cost)
    @id_number = id_number
    @ore_cost = ore_cost
    @clay_cost = clay_cost
    @obsidian_cost = obsidian_cost
    @geode_cost = geode_cost
  end 
  def get_id
    @id_number
  end

  def ore_cost
    @ore_cost
  end
  def clay_cost
    @clay_cost
  end
  def obsidian_cost
    @obsidian_cost
  end
  def geode_cost
    @geode_cost
  end

  def robot_production (all_robots, resources, time_elapsed)
    new_resources = all_robots.map{|r| r*time_elapsed}
    n=0
    while n<resources.length
    resources[n]+= new_resources[n]
    n+=1
    end
    return resources 
  end

  def build_ore(total_ore)
    total_ore = total_ore-@ore_cost
    return total_ore
  end

  def build_clay(total_ore)
    total_ore = total_ore - @clay_cost
  end

  def build_obsidian(total_ore, total_clay)
    total_ore = total_ore - @obsidian_cost[0]
    total_clay = total_clay - @obsidian_cost[1]
    return [total_ore, total_clay]
  end
  def build_geode(total_ore, total_obsidian)
    total_ore = total_ore - @geode_cost[0]
    total_obsidian = total_obsidian - @geode_cost[1]
    return [total_ore, total_obsidian]
  end
end

def build_ore_robot (current_blueprint, resources, all_robots)
  if resources[0] >= current_blueprint.ore_cost
    time_elapsed = 1
  else 
    time_elapsed = (current_blueprint.ore_cost - resources[0])/all_robots[0] + 1
    time_elapsed+=1 if (current_blueprint.ore_cost - resources[0])%all_robots[0]>0
  end 
  resources = current_blueprint.robot_production(all_robots, resources, time_elapsed)
  resources[0] = current_blueprint.build_ore(resources[0])
  all_robots[0]+=1
  return [resources, all_robots, time_elapsed]
end

def build_clay_robot (current_blueprint, resources, all_robots)
  if resources[0] >= current_blueprint.clay_cost
    time_elapsed = 1
  else 
    time_elapsed = (current_blueprint.clay_cost - resources[0])/all_robots[0] + 1
    time_elapsed+=1 if (current_blueprint.clay_cost - resources[0])%all_robots[0]>0
  end 
  resources = current_blueprint.robot_production(all_robots, resources, time_elapsed)
  resources[0] = current_blueprint.build_clay(resources[0])
  all_robots[1]+=1
  return [resources, all_robots, time_elapsed]
end

def limiting_factor(cost_first, first, first_robots, cost_second, second, second_robots)
  if (cost_first - first).to_f/first_robots > (cost_second-second).to_f/second_robots
    limiting_factor = 0
  else
    limiting_factor = 1
  end
  return (limiting_factor) 
end

def build_obsidian_robot (current_blueprint, resources, all_robots)
  if resources[0] >= current_blueprint.obsidian_cost[0] && resources[1] >= current_blueprint.obsidian_cost[1] 
    time_elapsed = 1
  elsif resources[0] >= current_blueprint.obsidian_cost[0]
    time_elapsed = (current_blueprint.obsidian_cost[1] - resources[1])/all_robots[1]  + 1
    time_elapsed+=1 if (current_blueprint.obsidian_cost[1] - resources[1])%all_robots[1]>0
  elsif resources[1] >= current_blueprint.obsidian_cost[1]
    time_elapsed = (current_blueprint.obsidian_cost[0] - resources[0])/all_robots[0]  + 1
    time_elapsed+=1 if (current_blueprint.obsidian_cost[0] - resources[0])%all_robots[0]>0
  else
    l=limiting_factor(current_blueprint.obsidian_cost[0], resources[0], all_robots[0], current_blueprint.obsidian_cost[1], resources[1], all_robots[1])
    time_elapsed = (current_blueprint.obsidian_cost[l] - resources[l])/all_robots[l]  + 1
    time_elapsed+=1 if (current_blueprint.obsidian_cost[l] - resources[l])%all_robots[l]>0
  end 
  resources = current_blueprint.robot_production(all_robots, resources, time_elapsed)
  resources[0], resources[1] = current_blueprint.build_obsidian(resources[0], resources[1])
  all_robots[2]+=1
  return [resources, all_robots, time_elapsed]
end

def build_geode_robot (current_blueprint, resources, all_robots)
  if resources[0] >= current_blueprint.geode_cost[0] && resources[2] >= current_blueprint.geode_cost[1] 
    time_elapsed = 1
  elsif resources[0] >= current_blueprint.geode_cost[0]
    time_elapsed = (current_blueprint.geode_cost[1] - resources[2])/all_robots[2]  + 1
    time_elapsed+=1 if (current_blueprint.geode_cost[1] - resources[2])%all_robots[2]>0
  elsif resources[2] >= current_blueprint.geode_cost[1]
    time_elapsed = (current_blueprint.geode_cost[0] - resources[0])/all_robots[0]  + 1
    time_elapsed+=1 if (current_blueprint.geode_cost[0] - resources[0])%all_robots[0]>0
  else
    l=limiting_factor(current_blueprint.geode_cost[0], resources[0], all_robots[0], current_blueprint.geode_cost[1], resources[2], all_robots[2])
    if l==0
    time_elapsed = (current_blueprint.geode_cost[l] - resources[l])/all_robots[l] + 1
    time_elapsed+=1 if (current_blueprint.geode_cost[l] - resources[l])%all_robots[l]>0
    elsif l==1
      time_elapsed = (current_blueprint.geode_cost[l] - resources[l+1])/all_robots[l+1] + 1
      time_elapsed+=1 if (current_blueprint.geode_cost[l] - resources[l+1])%all_robots[l+1]>0
    end
    
  end 
  resources = current_blueprint.robot_production(all_robots, resources, time_elapsed)
  resources[0], resources[2] = current_blueprint.build_geode(resources[0], resources[2])
  all_robots[3]+=1
  return [resources, all_robots, time_elapsed]
end

def build_robots(blueprints)
  n=2
  quality = 0
  while n<=(2)
    all_robots = [1, 0, 0, 0]
    resources = [0, 0, 0, 0]
    current_blueprint = blueprints[n]
    history = []
    time = 0
    state_of_world = [current_blueprint, all_robots, resources, time, history]
    best, best_state_of_world = make_recursive(state_of_world, [
      #"ore", "ore", "clay", "clay", "clay", "clay", "clay", "obsidian", "obsidian", "obsidian", "obsidian", "obsidian", "geode", "obsidian", "geode", "obsidian", "geode", "geode", "geode"
    ])
    puts "#{best_state_of_world[0].get_id} can produce #{best}"
   # puts
   # print "#{best_state_of_world[4]}"
   # puts
    score = best
    quality *= score
    n+=1
  end
  puts quality
end


def make_recursive(state_of_world, script)
 
  best = state_of_world[2][3]if best.nil?
  time = state_of_world[3]
  script_next = script.shift
  maximum_geodes = state_of_world[1][3]*(32-time) + state_of_world[2][3]+ ((32-time)*(32-time-1))/2
  if time >= 32
    return[best, state_of_world]
  else
    if (script_next == "ore") || (script_next == nil && (state_of_world[1][0]<=[state_of_world[0].clay_cost, state_of_world[0].geode_cost[0], state_of_world[0].obsidian_cost[0]].max)) && maximum_geodes > best
    ore_state_of_world = build_specific_robot(state_of_world, "ore")
    temp_time = ore_state_of_world[3]
    robots_so_far = ore_state_of_world[1]
    resources_so_far = ore_state_of_world[2]
    temp_decision= "ore"
    best_temp, ore_state_of_world = make_recursive(ore_state_of_world, script)
    if best_temp == [best_temp, best].max 
      decision = temp_decision
      best = best_temp
      time = temp_time
      robots = robots_so_far
      resources = resources_so_far
     best_state_of_world = ore_state_of_world
    end
  end
    if (script_next == "clay") || (script_next == nil && (state_of_world[1][1]<=state_of_world[0].obsidian_cost[1]) && maximum_geodes > best)
    clay_state_of_world = build_specific_robot(state_of_world, "clay")
    temp_time = clay_state_of_world[3]
    robots_so_far = clay_state_of_world[1]
    resources_so_far = clay_state_of_world[2]
    temp_decision= "clay"
    best_temp, clay_state_of_world = make_recursive(clay_state_of_world, script)
    if best_temp == [best_temp, best].max
      decision = temp_decision
      best = best_temp
      time = temp_time
      robots = robots_so_far
      resources = resources_so_far
      best_state_of_world=clay_state_of_world
    end
    end
    if (script_next == "obsidian") || (script_next == nil && state_of_world[1][1]>0 && state_of_world[1][2]<=state_of_world[0].geode_cost[1]&& maximum_geodes > best) 
    obs_state_of_world = build_specific_robot(state_of_world, "obsidian")
    robots_so_far = obs_state_of_world[1]
    resources_so_far = obs_state_of_world[2]
    temp_time=obs_state_of_world[3]
    best_temp, obs_state_of_world = make_recursive(obs_state_of_world, script)
    if best_temp == [best_temp, best].max
      decision = "obsidian"
      best = best_temp
      time = temp_time
      robots = robots_so_far
      resources = resources_so_far
      best_state_of_world=obs_state_of_world
    end
    end
    if (script_next == "geode") || (script_next == nil && state_of_world[1][2]>0 && maximum_geodes > best)
    geode_state_of_world = build_specific_robot(state_of_world, "geode")
    temp_time = geode_state_of_world[3]
    robots_so_far = geode_state_of_world[1]
    resources_so_far = geode_state_of_world[2]
    best_temp, geode_state_of_world = make_recursive(geode_state_of_world, script)
    if best_temp == [best_temp, best].max
      decision = "geode"
      best = best_temp
      best_state_of_world=geode_state_of_world
      time=temp_time
      robots = robots_so_far
      resources = resources_so_far
      
    end
  end
  unless best_state_of_world.nil? 
    best_state_of_world[4].append([decision, time, robots, resources])
    return[best, best_state_of_world]
  end
  return[25, state_of_world] 
  end
end
  

def build_specific_robot(state_of_world, specific)
if state_of_world[3]>=32
  return state_of_world
end
current_state = Marshal.load(Marshal.dump(state_of_world)) 
current_blueprint, all_robots, resources, time, history = current_state
if specific == "ore"
  resources, all_robots, time_elapsed = build_ore_robot(current_blueprint, resources, all_robots)
elsif specific == "clay"
  resources, all_robots, time_elapsed = build_clay_robot(current_blueprint, resources, all_robots)
elsif specific == "obsidian"
  resources, all_robots, time_elapsed = build_obsidian_robot(current_blueprint, resources, all_robots)
elsif specific == "geode"
  resources, all_robots, time_elapsed = build_geode_robot(current_blueprint, resources, all_robots)
end
time = time + time_elapsed
if time<=32
  current_state = [current_blueprint,all_robots, resources, time, history]
  return current_state
else
  current_state = Marshal.load(Marshal.dump(state_of_world)) 
  new_resources = current_state[2]
  new_resources = current_blueprint.robot_production(current_state[1], new_resources, (32-current_state[3]))
  current_state[3]=33
  current_state[2]=new_resources
  return (current_state)
end
end
  


def read_file
  blueprints = []
  lines = File.readlines('aoc_19_input.txt')
  lines.each do |l|
    l=l.split(":")
    id_number = l[0].scan(/\d+/).join.to_i
    l = l[1].split(".")
    ore_cost=l[0].scan(/\d+/).join.to_i
    clay_cost=l[1].scan(/\d+/).join.to_i
    obsidian_cost=l[2].scan(/\d+/)
    obsidian_cost.map! {|m| m.to_i}
    geode_cost=l[3].scan(/\d+/)
    geode_cost.map! {|m| m.to_i}
    blueprints.append(Blueprint.new(id_number, ore_cost, clay_cost, obsidian_cost, geode_cost))
  end
  return blueprints
end

blueprints = read_file
build_robots(blueprints)

#correct answer is 1349