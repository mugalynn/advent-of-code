$plan = Hash.new
$number_of_stacks

def move_crates_groups(piles)
  crates_to_move = []
  $plan.each do |k,v|
    number_of_moves = v[0]
    initial_crate = v[1]
    destination_crate = v[2]
    number_of_moves.times do
      crates_to_move.push(piles[initial_crate].pop)
      end
    crates_to_move = crates_to_move.reverse
    piles[destination_crate].concat(crates_to_move)
    crates_to_move=Array.new
  end
  return piles
end

def move_crates (piles)
  $plan.each do |k,v|
    number_of_moves = v[0]
    initial_crate = v[1]
    destination_crate = v[2]
    number_of_moves.times {
      crate_to_move = piles[initial_crate].pop
      piles[destination_crate].push(crate_to_move)
    }
  end
  return piles
end

def return_string (piles)
  array = Array.new
  counter=1
  #puts piles[]
  $number_of_stacks.times do
   top_crate=piles[counter].pop
   counter+=1
   array.push(top_crate)
  end
  puts array.join()
end


def make_stacks (stack_nums)
  piles = Hash.new
  counter = 0
  while counter <=$number_of_stacks
    piles[counter] = []
    counter +=1
  end
  counter = $number_of_stacks
  reverse_order = stack_nums.reverse
  reverse_order.each do |letter|
    if counter >=1
      if letter.match?(/[[:alpha:]]/)
        piles[counter].push(letter)
      end
    counter-=1
    elsif counter == 0
      counter=$number_of_stacks
      if letter.match?(/[[:alpha:]]/)
        piles[counter].push(letter)
      end
      counter-=1
    end
  end
 return(piles)
end

def read_file
  stack_nums = Array.new
  crates = Array.new
  counter = 0
  lines = File.readlines('crates.txt')
  lines.each do |line|
    if line.include? "move"
      instructions = line.gsub(/[^0-9]/, ' ')
      $plan[counter] = instructions.split(" ")
      $plan[counter].map!(&:to_i)
      counter +=1
    elsif line.include? "[" 
      n=0
      line.each_char do|char|
        if n==1
          stack_nums.push(char)
        elsif n%4==1
          stack_nums.push(char)
        end
        n +=1
        end
      elsif line.include? "1"
        line.each_char do|char|
          if char.match?(/[[:digit:]]/)
            $number_of_stacks = char.to_i
          end
        end
    end
  end
  $plan
  return(stack_nums)
end

stack_nums = read_file
$number_of_stacks
piles = make_stacks(stack_nums)
puts return_string(move_crates(piles))
piles = make_stacks(stack_nums)
puts return_string(move_crates_groups(piles))
