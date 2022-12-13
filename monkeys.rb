class Monkey

  def initialize(monkey_name, starting_items, test_do, operation, true_do, false_do)  
    @name=monkey_name
    @starting_items=starting_items
    @test_do = test_do
    @operation=operation
    @true_do=true_do
    @false_do=false_do
    @num
    @operator
    @divisible
    @activity=0
    self.parse_test

  end
  
  def throw_items
    @starting_items=Array.new
  end
  def assign_items(item)
    @starting_items.push(item)
  end
  
  def parse_test
    @test_do=@test_do.strip
    @divisible = @test_do.scan(/\d/).join('').to_i
    @true_do = @true_do.scan(/\d/).join('').to_i
    @false_do = @false_do.scan(/\d/).join('').to_i
  end
  
  def operation(num)
    @activity+=1
    @num = @operation.scan(/\d/).join('').to_i
    if @operation.include? "old * old"
       @operator = :*
       @num = num
    elsif @operation.include? "*"
        @operator = :*
    elsif @operation.include? "/"
        @operator = :/
    elsif @operation.include? "+"
        @operator = :+
    elsif @operation.include? "-"
        @operator = :-  
    end
  end
  
  def true_do
    return(@true_do)
  end
  def false_do
    return(@false_do)
  end
  def get_items
    return(@starting_items)
  end
  def use_operator
    return(@operator)
  end
  def use_num
    return(@num)
  end
  def divisible
    return(@divisible)
  end
  def return_activity
    return @activity
  end
end


def read_file
  starting_items = Array.new 
  monkey_list = Array.new
  m=0
  test_do = String.new
  monkey_name = String.new
  operation = String.new
  true_do = String.new
  false_do = String.new

  lines = File.readlines("monkeys.txt")
  lines.each do |line|
    if line.include? "Monkey"
      if m==0
      monkey_name = line.chop
      end
      if m>0
        monkey=Monkey.new(monkey_name, starting_items, test_do, operation, true_do, false_do)
        monkey_list.push(monkey)
        starting_items=Array.new
        m=0
      end
      m+=1
    elsif line.include? "Starting items"
      clean_up=line.split(": ")
      clean_up=clean_up[1].strip.split(", ")
      clean_up.each do |num|
        starting_items.push(num.to_i)
      end 
    elsif line.include? "Test"
      clean_up = line.split(": ")
      test_do = clean_up[1]
    elsif line.include? "Operation"
      clean_up = line.split(": ")
      operation=clean_up[1].strip
    elsif line.include? "If true" 
      true_do = line.strip
    elsif line.include? "If false"
      false_do = line.strip
  end
end
  return (monkey_list)  
end

def monkey_no_relief(monkey_list)
  supermodulo=1
  monkey_list.each do |monkey|
    supermodulo*=monkey.divisible
  end
  n=0
  while n<10000
    monkey_list.each_with_index do |monkey, i|
    #puts "I have #{monkey_list.length} monkeys"
    #puts "my items are #{monkey.get_items}"
    monkey_items = monkey.get_items
    monkey_items.each_with_index do |item, index|
      #puts "I am monkey #{i} my initial worry is #{item}"
      monkey.operation(item)
      item = item.public_send(monkey.use_operator, monkey.use_num)
      #puts "Uh oh. Worry increased to #{item}"
      item = item % supermodulo
       if item % monkey.divisible==0
          monkey_list[monkey.true_do].assign_items(item)
        else
          monkey_list[monkey.false_do].assign_items(item)
       end    
    end
    monkey.throw_items
    #puts "Now I have #{monkey.get_items}"
  end
  n+=1
  end
  monkey_list.each_with_index do |monkey, index|
  puts monkey.return_activity
end

  end
def monkey_business(monkey_list)
  n=0
  while n<20
    monkey_list.each_with_index do |monkey, i|
    puts "I have #{monkey_list.length} monkeys"
    puts "my items are #{monkey.get_items}"
    monkey_items = monkey.get_items
    monkey_items.each_with_index do |item, index|
      puts "I am monkey #{i} my initial worry is #{item}"
      monkey.operation(item)
      item = item.public_send(monkey.use_operator, monkey.use_num)
      puts "Uh oh. Worry increased to #{item}"
      item = (item/3).to_i
      puts "phew. Now it's #{item}"
       if item % monkey.divisible==0
          monkey_list[monkey.true_do].assign_items(item)
        else
          monkey_list[monkey.false_do].assign_items(item)
       end    
    end
    monkey.throw_items
    puts "Now I have #{monkey.get_items}"
  end
  n+=1
  end
  monkey_list.each_with_index do |monkey, index|
  puts monkey.return_activity
end

  end

def monkey_sort(monkey_list)
  monkey_bus=Array.new
  monkey_list.each_with_index do |monkey, index|
    monkey_bus[index] = monkey.return_activity
  end
  monkey_bus=monkey_bus.max(2)
  return(monkey_bus[0]*monkey_bus[1])
end


monkey_list = read_file
monkey_list = monkey_no_relief(monkey_list)
puts monkey_sort(monkey_list)