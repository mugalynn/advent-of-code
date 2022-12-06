def read_file
  assignments = Hash.new
  sections = Array.new
  counter = 0
  assignments[counter] = sections
  lines = File.readlines('assignments.txt')
  lines.each do |pair|
    half = pair.strip.split(',')
    assignments[counter] = half
    counter +=1
    sections = Array.new
  end
  return(assignments)
end

def assignment_range(assignments)
  assignments.each do |k, pair|
    full_set=Array.new
    pair.each do |individual| 
      single_range=Array.new
      single_range = individual.split("-")
      single_range.map!(&:to_i)
      full_set.concat(single_range)
    end
    assignments[k]= full_set
  end
 
 return(assignments)

end

def detect_full_containment(assignments)
  counter =0
  assignments.each do |k, ranges|
    #test if totally discrete
    if ranges[1]<ranges[2] || ranges[3] < ranges[0]
      puts "there is no overlap"
    #test if completely overlap
    elsif (ranges[2]>=ranges[0] && ranges[3]<=ranges[1]) || (ranges[0]>=ranges[2] && ranges[1]<=ranges[3])
      counter +=1
      puts "there is complete overlap"
    else
     puts "partial overlap"
     counter+=1
    
    end 
  end
  return(counter)
end


assignments=read_file
assignment_integers=assignment_range(assignments)
puts detect_full_containment(assignment_integers)