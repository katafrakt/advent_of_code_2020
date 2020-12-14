current_mask = ""
memory = {}

File.open("input").each do |line|
  if line =~ /mask = (.+)/
    current_mask = $1
  elsif line =~ /mem\[(\d+)\] = (\d+)/
    reg = $1.to_i
    number = $2.to_i
    num_as_str = reg.to_s(2).rjust(36, "0")
    new_num = ""
    num_as_str.split("").each_with_index do |num, idx|
      mask_bit = current_mask[idx]
      if mask_bit == 'X'
        new_num << 'X'
      elsif mask_bit == '1'
        new_num << '1'
      else
        new_num << num
      end
    end

    addresses = [new_num]
    while floating = addresses.detect { |a| a =~ /X/ }
      addresses.delete(floating)
      addresses << floating.sub('X', '1')
      addresses << floating.sub('X', '0')
    end
    
    addresses.each do |addr|
      num_addr = addr.to_i(2)
      memory[num_addr] = number
    end
  else
    raise "Shouldn't really be here"
  end
end

puts memory.values.sum