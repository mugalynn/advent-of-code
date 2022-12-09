def has_digits?(s)
  return !s[/\d/].nil?
end


def size_of_directory(manipulate_directory)
  directory = Marshal.load(Marshal.dump(manipulate_directory))
  size = Hash.new
  n=0
  while n<1000000
    directory.each do |key, array|
      array.each_with_index do |value, index|
        if (array.all? {|i| i.is_a?(Integer)})
          size[key]=array.sum
          n+=1
       end
        if value.is_a?(String) && size.has_key?(value)
         array[index]=size[value]
        end
      end
      
      end
  
  end
 
  return size
end

def read_file
  directory = Hash.new
  lines = File.readlines('disk.txt')
  key = 0
  location = Array.new

  lines.each do |line|
    if line.include? "$" #is it a command
       if line.include? "cd .." # do i need to move back in location
         location.pop
       elsif line.include? "cd"# I need a new key because I have new directory I'm moving into
         array=line.split
         key=array[2]
         location.push(key)
         directory[location.join('/')] = Array.new
       end
     elsif #all the non-command lines
      if has_digits?(line)
        list = line.split
        list = list[0].strip.to_i
      else 
        parts = line.split
        list = location.join('/') + '/' + parts[1]
      end

      
      directory[location.join('/')].push(list)
    end
    
  end
  return(directory)
end

directory=read_file
directory
sizes = size_of_directory(directory)
sum=0
sizes.each do |key, value|
  if value <= 100000
    sum+=value
  end
end
need_to_delete= 30000000-(70000000-sizes["/"])
puts sum



#1206825