def read_file
  instructions = File.readlines("cathode.txt")
  instructions.each do |n|
    n = n.strip
  end 
  return(instructions)
end

def display(array)
  print array[0..39].join
  puts
  print array[40..79].join
  puts 
  print array [80..119].join
  puts 
  print array[120..159].join
  puts 
  print array[160..199].join
  puts
  print array[200..239].join
end

def pixels(array)
  sprite_loc=Array.new
  display = Array.new(240, " ")
  array.each_with_index do |value, i|
    if i>0
    sprite_loc[i-1]=value[0]
    end
  end
  display_tracker=0
  sprite_loc.each_with_index do |x, i|
   row_position = i%40
   if x == (row_position-1) || x == (row_position) || x== (row_position+1)
    display[display_tracker] = "*"
   end
   display_tracker +=1
end
  display(display)

end


def run_code(array)
  register=1
  cycle =1
  signals=Array.new
  array.each_with_index do |code, index|
    if code.include? "addx" 
        #puts "During #{cycle} the register is #{register} and signal strength = #{(cycle)*register}"
        signals[cycle]=[register, cycle*register]
        instructions = code.split
        move=instructions[1].strip.to_i
       # puts "During #{cycle+1} the register is #{register} and signal strength = #{(cycle+1)*register}"
        signals[cycle+1]=[register, (cycle+1)*register]
        register += move
        cycle_plus=2
     else
      #puts "During #{cycle} the register is #{register} and signal strength = #{(cycle)*register}"
      signals[cycle]=[register, cycle*register]
      cycle_plus=1
   end
   cycle += cycle_plus
  end
  return signals
end
   

 instructions=read_file
 signals=run_code(instructions)
 #print signals
sum = signals[20][1]+signals[60][1]+signals[100][1]+signals[140][1]+signals[180][1]+signals[220][1]

pixels(signals)