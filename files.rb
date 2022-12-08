def has_digits?(s)
  return !s[/\d/].nil?
end


def size_of_directory(directory)
  
  size = Hash.new
  n=0
  while n<1000000
    directory.each do |key, array|
      if (array.all? {|i| i.is_a?(Integer)})
          size[key]=array.sum
          n+=1
      else 
        array.each_with_index do |value, index|
         if value.is_a?(String) && size.has_key?(value)
          array[index]=size[value]
         end
        
       end
      end
  
  end

  end
  return size
end

def read_file
  directory = Hash.new
  files = Array.new
  lines = File.readlines('disk.txt')
  key = 0
  directory[key]=files
  location = Array.new
  location[0] = 0
  n=0

  lines.each do |line|
    if line.include? "$" #is it a command
       if line.include? "cd .." # do i need to move back in location
         key=location[n-1]
         location.push(key)
         n-=1
         files=Array.new
       elsif line.include? "cd /" # am I here?
         key=location[n]
         files=Array.new
       elsif line.include? "cd"# I need a new key because I have new directory I'm moving into
         array=line.split
         key=array[2]
         while directory.has_key?(key)
           key.concat("_lower")
         end
         location.push(key)
         n+=1
         files=Array.new
       end
     elsif #all the non-command lines
      if line.include? "dir"
        list = line.split
        list = list[1].strip
  
      elsif has_digits?(line)
        list = line.split
        list = list[0].strip.to_i
      end
      if files.nil?
        files=list
      else 
          while directory.has_key?(list)
          list.concat("_lower")
          end
        if key==list
          list.concat("_lower")
        end
        files.push(list)
        directory[key]=files
      end
    end
    
  end
  return(directory)
end

directory=read_file
sizes=size_of_directory(directory)
sum=0
sizes.each do |key, value|
  if value <= 100000
    sum+=value
  end
end
puts directory[0]


#1206825