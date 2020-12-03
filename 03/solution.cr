require "big"

lines = Array(Array(Int32)).new
File.each_line("input") do |line|
  lines << line.split("").map {|c| c == "#" ? 1 : 0 }
end

map_length = lines[0].size
values = Array(Int32).new
[[1,1], [3,1], [5,1], [7,1], [1,2]].each do |combination|
  right, down = combination
  col = 0
  trees = 0
  lines.each_with_index do |line, idx|
    next unless idx % down == 0
    trees += line[col]
    col = (col + right) % map_length
  end

  values << trees
end
puts values[1]
puts values.map{|v| BigDecimal.new(v)}.product