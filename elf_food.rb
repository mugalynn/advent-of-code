lines = File.readlines('input.txt')
elf = Hash.new
snacks = Array.new
counter =1
elf[counter]=snacks
lines.each do |line|
 if line.chomp.empty?
    counter += 1
    snacks = Array.new
    elf[counter]=snacks
 else
   snacks.push(line.strip.to_i)
 end
end
elf.each do |number, array|
  total = array.sum
  elf[number] = total
end
top_three = elf.max_by(3) {|k,v|v}
puts top_three
total = top_three[0][1] + top_three[1][1] + top_three[2][1]
puts total
