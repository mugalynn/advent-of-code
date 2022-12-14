class Tree
  
  def initialize (height, visible)
    @height = height
    @visible = visible
    @scenic = 1

  end
  def display
    @display = [@height, @scenic]
  end
  def get_height
    @height
  end
  def get_visible
    @visible
  end
  def make_visible
    @visible = "y"
  end
  def scenic (score)
      @scenic *= score
  end
  def get_scenic
    @scenic
  end
end

def scenic_score (trees)
  trees.each do |k, array|
    array.each.with_index do |tree, index|
          i=index-1
            counter=0
          while (tree.get_height > array[i].get_height)    
            counter +=1
            i-=1
            if i <0
            break
            end
          end
          if i >= 0
            counter +=1
          end
          puts "#{tree.display} and #{counter}"
          tree.scenic(counter)
          if k == 0 || k == trees.length-1 || index ==0 || index ==array.length-1
            tree.scenic(0)
          end
      end
    end
      
      #compare from middle to right
  trees.each do |k, array|
    if k>0
     array.each.with_index do |tree, index|
       max_index = array.length-1
         i = index
         if i < max_index
          i+=1
         end
       counter = 0
       while (tree.get_height > array[i].get_height)
         counter +=1
         i +=1 
         if i>max_index  
          break
         end 
      end
      if i <= max_index
        counter +=1
      end
      
      tree.scenic(counter)
    end
  end
end
  #compare from middle to top
  trees.each do |k, array|
    if k>0
    array.each.with_index do |tree, index|
          i = k-1
          counter = 0
          while (tree.get_height > trees[i][index].get_height)
            counter +=1
            i-=1
            if i <0
            break
            end
          end
          if i >= 0
            counter +=1
          end

          tree.scenic(counter)
      end
      end
    end
    #compare from middle to bottom
    trees.each do |k, array|
      array.each.with_index do |tree, index| 
        i = k+1
         counter=0
         if i<(trees.length)
         while (tree.get_height > trees[i][index].get_height)   
            counter +=1
            i+=1
            if i > trees.length-1
              break
            end
          
            
          end
          if i <= trees.length-1
            counter +=1
          end
          tree.scenic(counter)
        end
    

  end
end
end

def print_tree (tree_map)
  sum =0
  index = 0
  tree_map.each do |k, array|
    print "the row #{k}"
    array.each do |tree|
      print " #{tree.display}"
      if tree.get_visible == "y"
        sum+=1
      end
      if tree.get_scenic > index
        index = tree.get_scenic
      end
    end
    puts
    
  end
  puts sum
  puts "the max scenic score is #{index}"
end


def calculate (trees)
  trees.each do |k, array|
    array.each.with_index do |tree, index|
          i=index-1
          counter=0
          while (tree.get_height > array[i].get_height) && tree.get_visible == "n"      
            counter +=1
            if counter == (index)
              tree.make_visible
            end
            i-=1
            if i <0
            break
            end
          end
      end
      end
      #compare from middle to right
  trees.each do |k, array|
    if k>0
     array.each.with_index do |tree, index|
       max_index = array.length-1
         i = index
         if i < max_index
          i+=1
         end
       counter = 0
       while (tree.get_height > array[i].get_height) && tree.get_visible == "n"
         counter +=1
         if counter == max_index-index
           tree.make_visible
         end
         i +=1 
         if i>max_index  
          break
         end 
      end
    end
  end
end
  #compare from middle to top
  trees.each do |k, array|
    if k>0
    array.each.with_index do |tree, index|
          i = k-1
          counter=0
          while (tree.get_height > trees[i][index].get_height) && tree.get_visible == "n"      
            counter +=1
            if counter == (k)
              tree.make_visible
            end
            i-=1
            if i <0
            break
            end
          end
      end
      end
    end
    #compare from middle to bottom
    trees.each do |k, array|
      array.each.with_index do |tree, index| 
        i = k+1
         counter=0
         if i<(trees.length)
         while (tree.get_height > trees[i][index].get_height) && tree.get_visible == "n"      
            counter +=1
            if counter == (trees.length-1-k)
                  tree.make_visible
            end
            i+=1
            if i > trees.length-1
              break
            end
          end
          end
        end
    

  end
end
    
  



def read_file
  trees = Hash.new
  array_of_trees = Array.new
  lines = File.readlines('tree_grid.txt')
  key = 0
  
  lines.each do |line|
    line=line.strip
    column = 0
    line.each_char do |char|
      if key == 0 || column == 0
       tree=Tree.new(char.to_i, "y")
      else 
        tree=Tree.new(char.to_i, "n")
      end
      array_of_trees.push(tree)
      column+=1
    end
    trees[key] = array_of_trees
    array_of_trees = Array.new
    key+=1
  end
  trees.each do |k,array|
    array.each.with_index do |tree, index|
    if k == trees.length-1
       tree.make_visible
    end
   if index == array.length-1
      tree.make_visible
    end
  #  print "row #{k} is #{tree.display}"
    end
    
 end
  return trees
end 

tree_map = read_file
tree_map = calculate(tree_map)
scenic_score(tree_map)
print_tree(tree_map)

#print_tree(tree_map)


