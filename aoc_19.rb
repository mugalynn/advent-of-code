def read_file
  starting_sequence = []
  lines = File.readlines('aoc_19_input.txt')
  lines.each do |l|
    l= l.strip
    l = l.to_i
    starting_sequence.concat([l])
  end
  #print starting_sequence
  starting_sequence
end

def mix(starting_sequence)
  hash_sequence = {}
  current = []
  starting_sequence.each_with_index do |v, i|
    hash_sequence[i] = [v, i]
   end
  starting_sequence.each_with_index do |v, i|
    #first assign new index to value...
    old_index = hash_sequence[i][1]
    new_index = old_index + v
  #  print hash_sequence
    if new_index > starting_sequence.length
      new_index = new_index % (starting_sequence.length-1)
    elsif new_index <= 0
      new_index = (starting_sequence.length-1) + new_index.remainder(starting_sequence.length)
    end
   puts "I'm shifting #{v} from #{old_index} to #{new_index}"
   #adjust the sequence of the rest
  # puts
   
   hash_sequence.each do |key, value|
    #check if the current
    if value[1] == old_index 
      value[1] = new_index
    elsif new_index > old_index && value[1] <= new_index && value[1]> old_index
       value[1]= (value[1] -1)
      if value[1] < 0
        value[1] = value[1] + (starting_sequence.length)
      end
    elsif new_index < old_index 
      if value[1] >= new_index && value[1] < old_index
        value[1]= (value[1] +1)
        if value[1] < 0
         value[1] = value[1].remainder(starting_sequence.length) + (starting_sequence.length)
        end
      elsif new_index==0 && (value[1] > old_index)
        value[1]= value[1]-1
      end

    end   
  
    end
  
    

    end
    #print "I'm going to try to sort this mess"
    #current= current_order(hash_sequence)
    hash_sequence
end

def find_value(final_shuffle)
final_shuffle = final_shuffle
start = final_shuffle.select {|key, value| value[0] == 0}
start = start.values[0][1]
nums=[]
modulos = [1000, 2000, 3000]
modulos.each_with_index do |m, i|
    index = (start+m)%(final_shuffle.length)
    puts index
    value = final_shuffle.select {|key, value| value[1] == index}
    puts
    print value
    puts
    value = value.values[0][0] 
    nums[i]=value
end

print nums

total = nums.sum

print "the total is #{total}"

end

def current_order (hash_sequence)
 # puts "I am sorting!"
  current_list = []
  n=0
while current_list.length < hash_sequence.length
 hash_sequence.each do |key, value|
    if value[1] == n
    current_list.push(value[0])
    n+=1
    end
  end
end
current_list
end


starting_sequence = read_file
final_shuffle = mix(starting_sequence)
find_value(final_shuffle)