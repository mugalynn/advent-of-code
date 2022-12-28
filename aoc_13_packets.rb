def read_file
  pairs=[]
  input = []
  lines = File.readlines('aoc_13_shorter_input.txt')
  lines.each do |line|
   line=line.strip
   
   unless line.empty?
  line = line.sub!("[", '')
   remove = line.rindex(']')
   line.slice!(remove)
   line = my_scan(line)
   if pairs.length < 2
      pairs.append(line)
   end
   if pairs.length == 2
      input.append(pairs)
      pairs = Array.new
   end  
  end
end
print input[1]
end

def my_scan s
  res = []
  s.scan(/((\d+)|(\[(.+)\]))/) do |match|
    if match[1]
      res << match[1].to_i
    elsif match[3]
      res << my_scan(match[3])
    end
    end
    res
  end
  


read_file