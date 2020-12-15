numbers = [11, 0, 1, 10, 5, 19]

class Machine
  property current_num
  @turn : Int32

  def initialize(numbers : Array(Int32))
    @history = {} of Int32 => Int32
    numbers.each_with_index do |n, idx|
      next if idx == numbers.size - 1
      @history[n] = idx
    end

    @turn = numbers.size - 1
    @current_num = numbers.last
  end

  def run_to(num_turns)
    loop do
      break if @turn == num_turns - 1

      if @history[@current_num]?.nil?
        #puts "First time! #{@current_num}"
        @history[@current_num] = @turn
        @current_num = 0
      else
        diff = @turn - @history[@current_num]
        #puts "Was #{diff} turns ago: #{@current_num}"
        @history[@current_num] = @turn
        @current_num = diff
      end

      #puts " -> #{@current_num}"
      @turn += 1
    end
  end
end

m = Machine.new(numbers)
m.run_to(30000000)
puts m.current_num
