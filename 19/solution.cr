class Result
  property success, pointer
  def initialize(@success : Bool, @pointer : Int32 = -1); end
end

abstract class Automaton
  abstract def consume(in : String, p : Int32) : Result
end

class TerminalAutomaton < Automaton
  def initialize(@character : Char); end

  def consume(input : String, pointer : Int32) : Result
    if input[pointer] == @character
      Result.new(true, pointer + 1)
    else
      Result.new(false)
    end
  end
end

class RefAutomaton < Automaton
  def initialize(@reflist : Array(Int32), @automata : Hash(Int32, Automaton)); end

  def consume(input : String, pointer : Int32) : Result
    init_result = Result.new(true, pointer)
    @reflist.reduce(init_result) do |result, ref|
      next result unless result.success

      @automata[ref].consume(input, result.pointer)
    end
  end
end

class AlternativeAutomaton < Automaton
  def initialize(@left : Automaton, @right : Automaton); end

  def consume(input : String, pointer : Int32) : Result
    lresult = @left.consume(input, pointer)
    return lresult if lresult.success
    @right.consume(input, pointer)
  end
end

LIST = Hash(Int32, Automaton).new

def parse_automaton_def(definition : String)
  result = definition.split(" | ")
  if result.size > 1
    AlternativeAutomaton.new(parse_automaton_def(result[0]), parse_automaton_def(result[1]))
  elsif definition =~ /"(\w)"/
    TerminalAutomaton.new($1.chars.first)
  else
    RefAutomaton.new(definition.split(" ").map{|i| i.to_i}, LIST)
  end
end

def run
  mode = :def
  matched = 0
  File.each_line("input") do |line|
    if line.empty?
      mode = :input
      next
    end

    case mode
    when :def
      label, rest = line.split(": ")
      LIST[label.to_i] = parse_automaton_def(rest)
    else
      re = LIST[0].consume(line, 0)
      matched += 1 if re.success && re.pointer == line.size      
    end
  end

  puts matched
end

run
