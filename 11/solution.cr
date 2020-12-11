struct Seat
  property x, y, occupied

  def initialize(@x : Int32, @y : Int32, @occupied : Bool)
  end
end

alias Coord = Tuple(Int32, Int32)
alias Seating = Hash(Coord, Seat)

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
].map { |c| Coord.new(c[0], c[1]) }

def get_adjacent_seats(seating, seat)
  DIRECTIONS.map do |dir|
    coord = Coord.new(seat.x + dir[0], seat.y + dir[1])
    seating[coord]?
  end.compact
end

def get_adjacent_seats2(seating, seat)
  max_x = seating.map {|_,s| s.x }.max
  max_y = seating.map {|_,s| s.y }.max

  DIRECTIONS.map do |dir|
    coord = Coord.new(seat.x, seat.y)
    loop do
      coord = Coord.new(coord[0] + dir[0], coord[1] + dir[1])
      break nil if coord[0] > max_x || coord[0] < 0 || coord[1] > max_y || coord[1] < 0
      maybe_seat = seating[coord]?
      break maybe_seat unless maybe_seat.nil?
    end
  end.compact
end

def solution(seating, method = ->get_adjacent_seats(Seating, Seat), occupied_limit = 4)
  current_hash = ""
  loop do
    new_hash = calculate_seating_hash(seating)
    break if new_hash == current_hash

    new_seating = {} of Coord => Seat
    seating.each do |_, seat|
      adjacent = method.call(seating, seat)
      coord = Coord.new(seat.x, seat.y)
      if seat.occupied && adjacent.count { |s| s.occupied } >= occupied_limit
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

solution(seating)
solution(seating, ->get_adjacent_seats2(Seating, Seat), 5)