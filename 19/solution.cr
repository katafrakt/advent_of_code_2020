class Result
  property success, pointer
  def initialize(@success : Bool, @pointer : Int32 = -1); end
end

abstract class Automaton
  abstract def _consume(in : String, p : Int32) : Array(Result)

  def consume(in : String, pointers : Array(Int32)) : Array(Result)
    valid_pointers = pointers.reject { |p| p >= in.size }
    results = valid_pointers.flat_map { |pointer| _consume(in, pointer) }
    results.reject { |r| r.pointer > in.size }.select { |r| r.success }
  end

  def consume(in : String, pointer : Int32) : Array(Result)
    consume(in, [pointer])
  end
end

class TerminalAutomaton < Automaton
  def initialize(@character : Char); end

  def _consume(input : String, pointer : Int32) : Array(Result)
    if input[pointer] == @character
      [Result.new(true, pointer + 1)]
    else
      [Result.new(false)]
    end
  end
end

class RefAutomaton < Automaton
  def initialize(@reflist : Array(Int32), @automata : Hash(Int32, Automaton)); end

  def _consume(input : String, pointer : Int32) : Array(Result)
    init_result = [Result.new(true, pointer)]
    @reflist.reduce(init_result) do |results, ref|
      successful = results.select { |r| r.success }
      next successful if successful.empty?

      @automata[ref].consume(input, results.map { |r| r.pointer })
    end
  end
end

class AlternativeAutomaton < Automaton
  def initialize(@left : Automaton, @right : Automaton); end

  def _consume(input : String, pointer : Int32) : Array(Result)
    lresults = @left.consume(input, pointer)
    rresults = @right.consume(input, pointer)

    (lresults + rresults).select{ |r| r.success }
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

def run(part = 1)
  mode = :def
  matched = 0
  File.each_line("input") do |line|
    if line.empty?
      mode = :input
      
      if part == 2
        # 8: 42 | 42 8
        # 11: 42 31 | 42 11 31
        LIST[8] = AlternativeAutomaton.new(RefAutomaton.new([42], LIST), RefAutomaton.new([42, 8], LIST))
        LIST[11] = AlternativeAutomaton.new(RefAutomaton.new([42,31], LIST), RefAutomaton.new([42,11,31], LIST))
      end

      next
    end

    case mode
    when :def
      label, rest = line.split(": ")
      LIST[label.to_i] = parse_automaton_def(rest)
    else
      re = LIST[0].consume(line, 0)
      valid = re.select {|r| r.success && r.pointer == line.size}
      matched += 1 unless valid.empty?     
    end
  end

  puts matched
end

run

run(2)