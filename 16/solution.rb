fields = {}

input = File.read("input")
defs, _my_ticket, other_tickets = input.split("\n\n")
defs.split("\n").each do |line|
  scan_result = line.scan(/(.+): (\d+-\d+) or (\d+-\d+)/)
  name, range1, range2 = scan_result.first
  
  range1 = Range.new *range1.split("-").map(&:to_i)
  range2 = Range.new *range2.split("-").map(&:to_i)
  fields[name] = [range1, range2]
end

invs = other_tickets.split("\n").drop(1).map do |ticket|
  nums = ticket.split(",").map(&:to_i)
  nums.reject {|num| fields.values.any?{|f| f.any? {|r| r.include?(num)}}}
end

puts invs.flatten.sum