fields = {}

input = File.read("input")
defs, my_ticket, other_tickets = input.split("\n\n")
defs.split("\n").each do |line|
  scan_result = line.scan(/(.+): (\d+-\d+) or (\d+-\d+)/)
  name, range1, range2 = scan_result.first
  
  range1 = Range.new *range1.split("-").map(&:to_i)
  range2 = Range.new *range2.split("-").map(&:to_i)
  fields[name] = [range1, range2]
end

invalid_fields_sum = 0
valid_tickets = other_tickets.split("\n").drop(1).select do |ticket|
  nums = ticket.split(",").map(&:to_i)
  invs = nums.reject {|num| fields.values.any?{|f| f.any? {|r| r.include?(num)}}}
  invalid_fields_sum += invs.sum
  invs.empty?
end

puts invalid_fields_sum

require 'set'

possible_fields = {}
valid_tickets.each do |ticket|
  nums = ticket.split(",").map(&:to_i)
  nums.each_with_index do |num, idx|
    valid_labels = Set.new
    fields.each do |label, ranges|
      valid_labels << label if ranges.any? {|r| r.include?(num)}
    end
    possible_fields[idx] = possible_fields[idx] ? possible_fields[idx] & valid_labels : valid_labels
  end
end

def_fields = {}
loop do
  singles = possible_fields.select {|_,set| set.size == 1}
  break if singles.empty?
  singles.each do |idx, single|
    single = single.to_a.first
    def_fields[idx] = single
    possible_fields.each {|_, s| s.delete(single)}
  end
end

departure_fields = def_fields.select{|idx, label| label =~ /departure/}

my_ticket_vals = my_ticket.split("\n").last.split(",").map(&:to_i)

result = 1
departure_fields.each do |idx, _|
  result *= my_ticket_vals[idx]
end

puts result