def random_weighted(weighted)
  max    = sum_of_weights(weighted)
  target = rand(1..max)

  weighted.each do |item, weight|
    return item if target <= weight
    target -= weight
  end
end

def sum_of_weights(weighted)
  weighted.inject(0) { |sum, (item, weight)| sum + weight }
end

# :cats

def pick_number
  random_weighted(cats: 5, dogs: 1)
end

# 1000.times { counts[pick_number] += 1 }
# p counts

def generate_personality(name)
  choices = ["rock", "paper", "scissors", "lizard", "spock"]
  hsh, arr = {}, []
  case name
    when 'R2D2' then hsh = Hash[choices.zip([0.6,0.1,0.1,0.1,0.1])]
    when 'Hal' then hsh = Hash[choices.zip([0.1,0.1,0.6,0.1,0.1])]
    when 'Chappie' then hsh = Hash[choices.zip([0.1,0.4,0.3,0.1,0.1])]
    when 'Sonny' then hsh = Hash[choices.zip([0.2,0.5,0.1,0.1,0.1])]
    when 'Number 5' then hsh = Hash[choices.zip([0.03,0.03,0.03,0.7,0.2])]
  end
  50.times { arr << hsh.max_by { |_, weight| rand ** (1.0 / weight) }.first }
end




p generate_personality('Hal')

# wrs = -> (freq) { freq.max_by { |_, weight| rand ** (1.0 / weight) }.first }
# p 1.times.map { wrs[choices] }
