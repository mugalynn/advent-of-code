def calculate_score(plays)
  if plays[1]=="X"
    score = 1
    if plays[0]=="A"
      score += 3
    elsif plays[0]=="B"
      score += 0
    elsif plays[0]=="C"
      score += 6
    end
  elsif plays[1]=="Y"
      score = 2
      if plays[0]=="A"
        score += 6
      elsif plays[0]=="B"
        score += 3
      elsif plays[0]=="C"
        score += 0
      end
  elsif plays[1]=="Z"
    score=3
    if plays[0]=="A"
      score += 0
    elsif plays[0]=="B"
      score += 6
    elsif plays[0]=="C"
      score += 3
    end
  end
  return(score)
end

def second_calc(plays)
  if plays[0]=="A"
    if plays[1] == "X"
      score = 3
    elsif plays[1] == "Y"
      score = 4
    elsif plays[1] == "Z"
      score = 8
    end
  elsif plays[0]=="B"
    if plays[1] == "X"
      score = 1
    elsif plays[1] == "Y"
      score = 5
    elsif plays[1] == "Z"
      score = 9
    end
  elsif plays[0]=="C"
    if plays[1] == "X"
      score = 2
    elsif plays[1] == "Y"
      score = 6
    elsif plays[1] == "Z"
      score = 7
    end
  end
end


game = Hash.new
counter = 0
sum = 0
round = Array.new
lines = File.readlines('rock_paper.txt')
lines.each do |line|
  game[counter]=round.push(line.split)
  counter +=1
  round = Array.new
end
game.each do |key, value|
  game[key]= second_calc(value[0])
  sum += game[key]
end
puts sum

