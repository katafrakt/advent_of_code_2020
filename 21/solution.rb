input_list = {}
all_ingredients = []

File.open("input") do |file|
  file.each do |line|
    ingredients, allergenes = line.scan(/(.+) \(contains (.+)\)/).flatten
    ingredients = ingredients.split(" ")
    all_ingredients += ingredients
    allergenes = allergenes.split(", ")
    allergenes.each do |allerg|
      input_list[allerg] = input_list.fetch(allerg, []) + [ingredients]
    end
  end
end

possibilities = {}
input_list.each do |allergene, foods|
  possible_ingredients = foods.flatten.uniq
  possible_ingredients.each do |ing|
    possibilities[allergene] ||= []
    possibilities[allergene] << ing if foods.all? {|f| f.include?(ing)}
  end
end

found = {}
loop do
  allergene, foods = possibilities.detect {|a,is| is.size == 1 }
  break if allergene.nil?

  food = foods.first
  found[allergene] = food
  possibilities.each do |k,set|
    set.delete(food)
  end
end

non_allergic_ingredients = all_ingredients.uniq - found.values
puts all_ingredients.count {|x| non_allergic_ingredients.include?(x) }
puts found.sort.to_h.values.join(",")