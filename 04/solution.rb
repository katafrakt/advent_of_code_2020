required = {
  "byr" => ->(v) { v.to_i >= 1920 && v.to_i <= 2002 },
  "iyr" => ->(v) { v.to_i >= 2010 && v.to_i <= 2020 },
  "eyr" => ->(v) { v.to_i >= 2020 && v.to_i <= 2030 },
  "hgt" => ->(v) { (v =~ /(\d+)cm/ && $1.to_i >= 150 && $1.to_i <= 193) || (v =~ /(\d+)in/ && $1.to_i >= 59 && $1.to_i <= 76) },
  "hcl" => ->(v) { /#[0-9a-f]{6}/.match?(v) },
  "ecl" => ->(v) { %w(amb blu brn gry grn hzl oth).include?(v) },
  "pid" => ->(v) { /^\d{9}$/.match?(v) }
}
input = File.read('input')
valid1 = input.split("\n\n").map { |e| e.gsub("\n", " ").split(" ").map {|part| part.strip.split(":") }}.select { |ps| (ps.flat_map(&:first) & required.keys).size == required.keys.size }
puts valid1.size
puts valid1.count { |data| data.all?{ |k,v| required[k].nil? || required[k].call(v) } }