struct Instruction
  property command, argument

  def initialize(@command : String, @argument : Int32)
  end
end

class AsmVM
  def initialize(@instructions : Array(Instruction))
    @accumulator = 0
    @current_instr = 0
    @instr_history = Set(Int32).new
    @finished = false
  end

  def run
    loop do
      evaluate_instruction()
      break if @instr_history.includes?(@current_instr)

      if @current_instr >= @instructions.size
        @finished = true
        break
      end
    end
  end

  def accumulator
    @accumulator
  end

  def finished?
    @finished
  end

  private def evaluate_instruction()
    instr = @instructions[@current_instr]
    @instr_history << @current_instr
    case instr.command
    when "nop"
      @current_instr += 1
    when "acc"
      @accumulator += instr.argument
      @current_instr += 1
    when "jmp"
      @current_instr += instr.argument
    end
  end
end

instructions = [] of Instruction
File.each_line("input") do |line|
  instr, arg_str = line.split(" ")
  instructions << Instruction.new(instr, arg_str.to_i)
end

vm = AsmVM.new(instructions)
vm.run
puts vm.accumulator

instructions.each_with_index do |instr, idx|
  next if instr.command == "acc"

  replacement = if instr.command == "jmp"
    Instruction.new("nop", instr.argument)
  else
    Instruction.new("jmp", instr.argument)
  end

  copy = instructions.dup
  copy[idx] = replacement
  vm = AsmVM.new(copy)
  vm.run

  if vm.finished?
    puts vm.accumulator
    break
  end
end