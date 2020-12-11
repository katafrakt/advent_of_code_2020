struct Seat
  property x, y, occupied

  def initialize(@x : Int32, @y : Int32, @occupied : Bool)
  end
end

alias Coord = Tuple(Int32, Int32)

seating = {} of Coord => Seat

fname = "input"
File.open(fname) do |file|
  file.each_line.with_index do |line, lidx|
    line.split("").each_with_index do |val, vidx|
      if val == "L"
        coord = Coord.new(lidx, vidx)
        seating[coord] = Seat.new(lidx, vidx, false)
      end
    end
  end
end

def calculate_seating_hash(seating)
  seating
    .map {|_, s| [s.x, s.y, s.occupied.to_s].join("-").as(String) }
    .join(" ")
end

DIRECTIONS = [
  [1,1], [1,0], [1,-1],
  [0,1], [0,-1],
  [-1,1], [-1,0], [-1,-1]
]

def get_adjacent_seats(seating, seat)
  DIRECTIONS.map do |dir|
    coord = Coord.new(seat.x + dir[0], seat.y + dir[1])
    seating[coord]?
  end.compact
end

def solution1(seating)
  current_hash = ""
  loop do
    new_hash = calculate_seating_hash(seating)
    break if new_hash == current_hash

    new_seating = {} of Coord => Seat
    seating.each do |_, seat|
      adjacent = get_adjacent_seats(seating, seat)
      coord = Coord.new(seat.x, seat.y)
      if seat.occupied && adjacent.count { |s| s.occupied } >= 4
        new_seating[coord] = Seat.new(seat.x, seat.y, false)
      elsif !seat.occupied && adjacent.all? { |s| !s.occupied }
        new_seating[coord] = Seat.new(seat.x, seat.y, true)
      else
        new_seating[coord] = seat
      end
    end

    print "."
    seating = new_seating
    current_hash = new_hash
  end

  puts ""
  puts seating.count { |_,s| s.occupied }
end

solution1(seating)