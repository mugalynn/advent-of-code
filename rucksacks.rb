def halves(str)
  [str[0, str.size/2], str[str.size/2..-1]]
end

def values(str)
  str.each_byte do |c|
    if c>96 && c<123
    priority = c-96
    elsif c>64 && c<91
      priority = c-38
    else priority = 0
    end
    return(priority)
  end
  
end

def rucksack_sort (lines)
counter=0
extra_item = Hash.new
duplicates = Array.new
extra_item[counter] = duplicates
packing_list = Hash.new
rucksack = Array.new
packing_list[0]=rucksack
  lines.each do |line|
    rucksack = halves(line)
    packing_list[counter] = rucksack
    rucksack[0].chars.each do |char|
      if rucksack[1].include? char
        extra_item[counter]= values(char)
      end
    end
    duplicates = Array.new
    counter +=1
    end
    total = 0
extra_item.each do |k, v|
  total += v
end
 return(total)
end

def groups(lines)
  elf_groups = Hash.new
  group_of_three = Array.new
  counter = 0
  elf_groups[counter] = group_of_three
  n=-1
  lines.each do |rucksack|
    if n<2
      n+=1
      elf_groups[counter] = group_of_three
      #don't need new group
    elsif n==2
      puts "I'm here!"
      elf_groups[counter] = group_of_three
      puts elf_groups[counter]
      counter += 1
      group_of_three = Array.new
      n=0
    end
    group_of_three.push(rucksack.strip)
    end

return(elf_groups)
end

def common_element(elf_groups)
  possible_matches = []
  elf_groups[0].chars.each do |char|
    if elf_groups[1].include? char
      possible_matches.push(char)
    end
  end

  possible_matches.each do |char|
    if elf_groups[2].include? char
      possible_matches = char
    end
  end
  return(possible_matches)

end

lines = File.readlines('rucksacks.txt')
priorities = Array.new
elf_groups = groups(lines)
puts elf_groups
elf_groups.each do |h, k|
  priorities.push(values(common_element(k)))
end
total=0
priorities.each do |v|
  total +=  v
end
puts total

