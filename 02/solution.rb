valid_1 = valid_2 = 0
File.readlines("input").each do |line|
  req, value = line.split(': ')
  characters = value.split("")
  rng, letter = req.split(' ')
  min, max = rng.split('-').map(&:to_i)
  freq = characters.tally[letter] || 0
  valid_1 += 1 if freq >= min && freq <= max

  if [characters[min-1], characters[max-1]].count {|c| c == letter} == 1
    valid_2 += 1 
  end
end

puts valid_1
puts valid_2