current_mask = ""
memory = {}

File.open("input").each do |line|
  if line =~ /mask = (.+)/
    current_mask = $1
  elsif line =~ /mem\[(\d+)\] = (\d+)/
    reg = $1.to_i
    number = $2.to_i
    num_as_str = number.to_s(2).rjust(36, "0")
    new_num = ""
    num_as_str.split("").each_with_index do |num, idx|
      mask_bit = current_mask[idx]
      if mask_bit == 'X'
        new_num << num
      else
        new_num << mask_bit
      end
    end
    memory[reg] = new_num.to_i(2)
  else
    raise "Shouldn't really be here"
  end
end

puts memory.values.sum