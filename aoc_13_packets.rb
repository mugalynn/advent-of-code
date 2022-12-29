require 'json'

def read_file
  pairs=[]
  input = []
  lines = File.readlines('aoc_13_shorter_input.txt')
  lines.each do |line|
   line=line.strip
   
   unless line.empty?
   line = JSON.parse(line)
   if pairs.length < 2
      pairs.append(line)
   end
   if pairs.length == 2
      input.append(pairs)
      pairs = Array.new
   end  
  end
end
return input
end

def read_file_part_two
  input = []
  lines = File.readlines('AOC_13_input.txt')
  lines.each do |line|
    line=line.strip 
    unless line.empty?
    line = JSON.parse(line)
    input << line
   end
   
end
return input
end

def bubblesorter(array)
   k = array.length
   w = 0
   
  while w <= k
   i = 0 
    swap_made = false
     while i < ((k-w)-1)

       if compare(array[i], array[i+1], 1) == 0
         array[i], array[i+1] = array[i+1], array[i]
         swap_made = true 
       end
      i += 1 
     end
     if swap_made == false 
      break
     end
     w+=1  
     end
  array
end



def compare(left, right, index)
  if right.nil?
    return 0
  end
  if left.nil? 
    return index
  end
  if right.is_a?(Integer)
    right = [right]
  end
  if left.is_a?(Integer)
    left = [left]
  end
  # might need code for evaluating integers? Definitely need code that converts an integer to a list.
  
  left.each_with_index do |v, i|
    if (v.is_a?(Integer)) && (right[i].is_a?(Integer))
      if v>right[i]
        return 0
      elsif v<right[i]
        return index
      elsif v == right[i]
        next
      end 
    elsif (v.is_a?(Integer)) && (right[i].nil?)
      return 0
    elsif (v.nil? && right[i].is_a?(Integer))
      return index
    elsif (v.kind_of?(Array)) && (right[i].kind_of?(Array))
       output = compare(v, right[i], index)
       return output if output != "equal"
    elsif right[i].kind_of?(Array) && v.is_a?(Integer)
      output = compare([v], right[i], index)
       return output if output != "equal"
    elsif v.kind_of?(Array) && right[i].is_a?(Integer) 
      output = compare(v, [right[i]], index) 
      return output if output != "equal"
    end 
  end
  if left.length < right.length
    return index
  elsif right.length < left.length
    return 0
  else
  return ("equal")
  end
end

def part_one
input = read_file
sum = 0
input.each_with_index do |pair, i|
  index = i+1
  add = compare(pair[0], pair[1], index)
  sum += add
end
puts sum
end


input = read_file_part_two
sorted = bubblesorter(input)
decoder_key = (sorted.find_index([[2]])+1) * (sorted.find_index([[6]])+1)
puts decoder_key