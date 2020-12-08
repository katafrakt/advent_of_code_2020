rules = {}
File.open('input').each do |line|
  main_label, raw_rule = line.scan(/(\w+ \w+) bags contain (.*)$/).flatten
  parts = raw_rule.split(", ")
  parts.map! do |rule|
    num, label = rule.scan(/(\d+) (\w+ \w+) bag/).flatten
    next if label.nil?
    [label, num.to_i]
  end
  rules[main_label] = Hash[parts.compact]
end

bags = ['shiny gold']
loop do
  candidate_bags = bags.flat_map do |bag|
    rules.reject {|k,v| v[bag].nil? }.keys
  end.uniq
  break if (candidate_bags + bags).uniq == bags
  bags = (candidate_bags + bags).uniq
end
puts bags.size - 1

current_bags = [{'shiny gold' => 1}]
loop do
  next_bags = current_bags.last.flat_map do |k,v|
    inside = rules[k]
    inside.map { |x,y| {x => y*v}}
  end
  next_layer = {}
  next_bags.each do |set|
    set.each do |k,v|
      next_layer[k] = next_layer.fetch(k, 0) + v
    end
  end
  break if next_layer.empty?
  current_bags << next_layer
end
total = current_bags.map do |hash|
  hash.values.sum
end.sum
puts total - 1