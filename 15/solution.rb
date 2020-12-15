numbers = [11,0,1,10,5,19]
history = numbers.dup
turns = 2020

(turns-numbers.size).times do
  last_spoken = history.last
  if history.count(last_spoken) == 1
    history << 0
  else
    number_history = history.each_index.select {|i| history[i] == last_spoken}
    history << number_history[-1] - number_history[-2]
  end
end

puts history.last