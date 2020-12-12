alias Coord = Tuple(Int32, Int32)
struct Direction
  property left, right, coord 

  def initialize(@left : String, @right : String, coord : Array(Int32))
    @coord = Coord.new(coord[0], coord[1])
  end

  def turn(dir : String)
    dir == "R" ? @right : @left
  end
end

ROSE = {
  "E" => Direction.new("N", "S", [1,0]),
  "S" => Direction.new("E", "W", [0,-1]),
  "W" => Direction.new("S", "N", [-1,0]),
  "N" => Direction.new("W", "E", [0,1])
}

class Ship
  property direction : String, coord : Coord

  def initialize
    @direction = "E"
    @coord = Coord.new(0,0)
  end

  def process_instruction(instr)
    dir, value = process_instr(instr)

    case dir
    when "N", "S", "E", "W"
      move_in_direction!(ROSE[dir], value)
    when "F"
      move_in_direction!(ROSE[@direction], value)
    when "R", "L"
      turns = (value/90).to_i
      turn!(dir, turns)
    end
  end

  def manhattan
    @coord[0].abs + @coord[1].abs
  end

  private def process_instr(instr : String) : Tuple(String, Int32)
    match_data = instr.match(/(\w)(\d+)/).not_nil!
    dir : String = match_data[1]
    value : Int32 = match_data[2].to_i
    {dir, value}
  end

  private def move_in_direction!(direction, value)
    @coord = Coord.new(
      @coord[0] + (direction.coord[0] * value),
      @coord[1] + (direction.coord[1] * value)
    )
  end

  private def turn!(direction, turns)
    turns.times do
      dir = ROSE[@direction]
      @direction = dir.turn(direction)
    end
  end
end

class Ship2 < Ship
  property waypoint : Coord

  def initialize
    super
    @waypoint = Coord.new(10, 1)
  end

  def process_instruction(instr)
    dir, value = process_instr(instr)

    case dir
    when "N", "S", "E", "W"
      move_waypoint!(ROSE[dir], value)
    when "F"
      move_to_waypoint!(value)
    when "R", "L"
      turns = (value/90).to_i
      rotate_waypoint!(dir, turns)
    end
  end

  private def move_waypoint!(direction, value)
    @waypoint = Coord.new(
      @waypoint[0] + (direction.coord[0] * value),
      @waypoint[1] + (direction.coord[1] * value)
    )
  end

  private def move_to_waypoint!(value)
    @coord = Coord.new(
      @coord[0] + (@waypoint[0] * value),
      @coord[1] + (@waypoint[1] * value)
    )
  end

  private def rotate_waypoint!(direction, turns)
    turns.times do
      if direction == "L"
        @waypoint = Coord.new(-1 * @waypoint[1], @waypoint[0])
      else
        @waypoint = Coord.new(@waypoint[1], -1 * @waypoint[0])
      end
    end
  end
end

ship = Ship.new
ship2 = Ship2.new

File.open("input").each_line do |line|
  ship.process_instruction(line.chomp)
  ship2.process_instruction(line.chomp)
end

puts ship.manhattan
puts ship2.manhattan