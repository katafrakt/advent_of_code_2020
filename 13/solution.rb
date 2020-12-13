f = File.open("input")
time = f.readline.to_i
schedules = f.readline.split(",").map(&:to_i).reject(&:zero?).map do |l|
  [l, l - (time % l)]
end
bus = schedules.min_by {|x| x[1]}
puts bus[0] * bus[1]