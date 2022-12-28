def read_file
  lines = File.readlines('aoc_13_shorter_input.txt')
  pairs = []
  individual_pair = []
  
  lines.each_with_index do |line, index|
    if line.kind_of?(Array)
      next
    end
    line = line.strip
    num = line.count('[')
    n=index
    while individual_pair.length < 2 && num >0
      if num == 1
      lines[n] = lines[n].tr('[]', '')
      lines[n] = lines[n].split ","
      lines[n] = lines[n].map(&:to_i)
      individual_pair.append(lines[n])
      n+=1
      end
      if num > 1
        lines[n] = lines[n].sub!("[", '')
        remove = lines[n].rindex(']')
        lines[n].slice!(remove)
        number_of_lists = num-1
        while number_of_lists>0
          list = Array.new
          lines[n].sub!("[", '')
          lines[n].slice!(lines[n].rindex(']'))
          lists = lines[n].split "],["
          number_of_lists -=2
        end
        n+=1
      end
    end
    if individual_pair.length == 2
      pairs.append(individual_pair)
      individual_pair = Array.new
    end
    
  end
end

read_file