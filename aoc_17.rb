$falling
$counter

def read_file
  lines = File.readlines('aoc_17_rocks.txt')
  n = 0
  rocks = {}
  lines.each_with_index do |line, _i|
    line = line.strip
    n += 1 if line.empty?
    unless line.empty? || line.nil?
      if rocks[n]
        rocks[n].push(line)
      else
        rocks[n] = [line]
      end
    end
  end
  lines = File.readlines('aoc_17_full.txt')
  jets = []
  lines.each do |line|
    line = line.strip.split('')
    jets.concat(line)
  end
  [rocks, jets]
end

def calculate
  cycle_numbers=(1000000000000 - $indices[0]) / $repeat_height
  remainder = (1000000000000 - $indices[0]) % $repeat_height
  [cycle_numbers, remainder]
end

def make_space
  space = Array.new(21, '.')
  floor = Array.new(7, 'x')
  space += floor
  space
end

def save_space (space)
  save=space.join
  File.write("space.txt", save, mode: "w+")
end

def save_rock_heights
  save=$rock_heights.join(",")
  File.write("rock_heights.txt", save, mode: "w+")
end

def load_rock_heights
  heights = []
  File.readlines("rock_heights.txt").each do |line|
    line = line.split(",")
    line.map! {|i| i.to_i}
    heights.concat(line)

  end
  return heights
end

def load_space
  space=[]
  File.readlines("space.txt").each do |line|
    line=line.split("")
    space.concat(line)
  end
  space
end

def trim_grid (space)
  #check air
  top=0
  n=0
while n<20
space.each_with_index do|space, i|
    if space=="#"
      top = i
      break
    end
  end
if  top >=28
  space.slice!(0..6)
#  puts "I deleted a row!"
end
n+=1
   # top=space.find {"#"}
end
  return space
end

def find_repeat_heights
  heights = load_rock_heights
  #print heights
  height_diff = [0]
  n=1
  while n<heights.length
    height_diff[n] = heights[n]-heights[n-1]
    n+=1
  end
  heights_slice = height_diff[4000..4500].join(",")
  heights_as_string= height_diff[..height_diff.length-1].join(",")
  $indices= heights_as_string.enum_for(:scan, heights_slice).map do
    Regexp.last_match.offset(0).first
  end
  print $indices
  garbage = $indices.map! do |n|
    n = n/2
  end
  print $indices
  
  $repeat_height = $indices[$indices.length-1] - $indices[$indices.length-2]
  puts $repeat_height
  
  #print height_diff
  cycle_number, remainder = calculate
  total_height = heights[$indices[0]-1] + cycle_number * (height_diff[$indices[1]..($indices[2]-1)].sum)+ height_diff[$indices[1]..($indices[1]+remainder-1)].sum
  puts "the total height is #{total_height}"
  #puts "the height difference between #{indices[2]} and #{indices[3]-1} = #{heights[28839] - heights[25360]} does that match? #{heights[32319]-heights[28840]}"
# have already tried 1582758620702 or 1582758620705
end

def find_repeat
  space = load_space
  space_slice = space[3500..35240].join
  space_as_string = space[..space.length-1].join
  indices = space_as_string.enum_for(:scan, space_slice).map do
    Regexp.last_match.offset(0).first
  end
  repeat = indices[indices.length-1] - indices[indices.length-2]
  puts repeat
end

def new_rock(_rocks, _index, _space)
  rocks = _rocks
  index = _index
  space = _space
  #display_grid(space)
 # puts "I'm about to be trimmed"
  trim_grid(space)
  rock = rocks[index]
  length = rock.length
  # write bottom of rock
  n = length-1
  while n >= 0
    rock[n].gsub!("#", "$")
    line = '..' + rock[n]
    line = line.ljust(7, '.').split('')
    space = line + space
    n -= 1
  end
  #puts "I'm a new rock!"
 # display_grid(space)
  [space, rock]
end

def shift_left(space, crash)
  p = 0
  m=true
  while p < crash
    m = false if (p % 7 == 0 || space[p-1] == "#") && (space[p] == '$') 
    p += 1
  end
  p=0
  if m == true
    while p < crash
      if space[p+1] == '$'
        space[p] = space[p+1]
        if space[p+2] == '.' || space[p+2] == "x" || space[p+2] == "#"
          space[p+1]='.'
        end
      end
      p += 1
    end
  end
  space
end

def shift_right(space, crash)
  p = 0
  m = true
  while p < crash
    m = false if (p % 7 == 6  || space[p+1] == "#") && (space[p] == '$')
    p += 1
  end
  p = crash
  if m == true
    while p > 0
      if space[p-1] == '$'
        space[p]=space[p-1]
        if space[p-2] != "$"
          space[p-1]= "."
        end
      end
      p-=1
    end
    end

  space
end

def fall(space, crash)
  p = 0
  m = true
  while p < crash
    m = false if space[p] == "$" && space[p + 7] == '#' || space[p+7] == "x"
    p += 1
  end
  p = crash
  while p>0
  if m == true && (space[p] == '$')
    space[p + 7] = space[p]
    if space[p-7] != "$" || p<7
      space[p]="."
    end
  end
    p -= 1
  end
  if m==false
    space.each_with_index do|pixel, i|
    if pixel == "$"
      space[i] = "#"
    end
    end
  $falling = false
  end
  space
end

def height(space)
  top =1
  space.each_with_index do|space, i|
    if space=="#"
      top = i
      break
    end
  end
  top = top/7
  bottom = (space.length-7)/7
  height = bottom - top
  height

end

def rock_fall(_rocks, _jets, _space)
  $rock_heights = []
  rocks = _rocks
  jets = _jets
  space = _space
  jets = jets
  $counter=0
  j = 0
  while $counter < 20000
    space, rock = new_rock(rocks, $counter%5, space)
   # display_grid(space)
    depth = rock.length
    $falling = true
    crash = depth * 7
    while $falling == true
      jet = jets[j]
     # puts jets[j]
      if jet == '<' # shift left
        space = shift_left(space, crash)
     #  puts "I shifted left"
      # display_grid(space)
      elsif jet == '>' # shift right
        space = shift_right(space, crash)
     #   puts "I shifted right"
     #  display_grid(space)
      end
   space = fall(space, crash)
   unless $falling == false
   # puts "I fell"
      crash+=7    
    end
    j+=1
    if j==jets.length
      j=0
    end
  end
   # display_grid(space)

  $rock_heights.concat([height(space)])
  
  $counter+=1
  end
  save_rock_heights
  space
end

def display_grid(_space)
  
  space = _space
  n=0
  while n<280
    if space[n+6]
      print space[n..(n + (7 - 1))].join
      puts
    end
    n += 7
  
end

#  puts "blah"
end

#rocks, jets = read_file
#space = make_space
#space = rock_fall(rocks, jets, space)
#save_space
#print load_space
#heights = load_rock_heights
find_repeat_heights